import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/sale_sync.dart';
import '../../domain/repositories/sales_repository.dart';

class DriftSalesRepository implements SalesRepository, SaleOutboxStore {
  DriftSalesRepository(this._database);

  static const createOperation = 'sale_intent_create';
  static const confirmOperation = 'sale_intent_confirm';
  final AppDatabase _database;

  @override
  Future<String> register({
    required String localSaleId,
    required String clientRequestId,
    required SaleDraft draft,
    required DateTime createdAt,
  }) async {
    if (!_uuidPattern.hasMatch(clientRequestId)) {
      throw const SaleRegistrationException(
        'invalid_client_request_id',
        'client_request_id precisa ser um UUID válido.',
      );
    }
    if (draft.items.isEmpty || draft.items.any((item) => item.quantity <= 0)) {
      throw const SaleRegistrationException(
        'invalid_sale',
        'A venda exige ao menos um item com quantidade válida.',
      );
    }
    if (draft.timezone.trim().isEmpty) {
      throw const SaleRegistrationException(
        'invalid_timezone',
        'A venda exige timezone explícito.',
      );
    }
    final remoteItems = <SaleIntentItem>[];
    final productIds = <int>{};
    for (final item in draft.items) {
      final productId = _positiveRemoteId(item.productId, 'product_id');
      if (!productIds.add(productId)) {
        throw const SaleRegistrationException(
          'duplicate_product',
          'A venda não pode repetir o mesmo produto em itens separados.',
        );
      }
      remoteItems.add(
        SaleIntentItem(productId: productId, quantity: item.quantity),
      );
    }
    final payload = SaleIntentPayload(
      clientRequestId: clientRequestId,
      clientId: _positiveRemoteId(draft.clientId, 'client_id'),
      soldAt: _iso8601WithOffset(draft.soldAt),
      timezone: draft.timezone,
      items: remoteItems,
    );
    final payloadJson = _encodePayload(payload);

    await _database.transaction(() async {
      await _database.into(_database.localSalesTable).insert(
        LocalSalesTableCompanion.insert(
          id: localSaleId,
          clientRequestId: clientRequestId,
          clientId: draft.clientId,
          clientName: draft.clientName,
          soldAt: draft.soldAt,
          timezone: draft.timezone,
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      );
      await _database.batch((batch) {
        batch.insertAll(
          _database.localSaleItemsTable,
          [
            for (final item in draft.items)
              LocalSaleItemsTableCompanion.insert(
                saleId: localSaleId,
                productId: item.productId,
                productName: item.productName,
                productSku: Value(item.productSku),
                quantity: item.quantity,
                historicalUnitPrice: Value(item.historicalUnitPrice),
              ),
          ],
        );
      });
      await _database.into(_database.syncOutbox).insert(
        SyncOutboxCompanion.insert(
          id: localSaleId,
          clientRequestId: Value(clientRequestId),
          operationType: const Value(createOperation),
          localOperationId: Value(localSaleId),
          payloadJson: Value(payloadJson),
          payloadVersion: const Value(SaleIntentPayload.version),
          status: SaleSyncStatus.pending.databaseValue,
          attempts: const Value(0),
          createdAt: Value(createdAt),
          updatedAt: Value(createdAt),
        ),
      );
    });
    return localSaleId;
  }

  @override
  Future<OutboxSale?> read(String id) async {
    final row = await (_database.select(_database.syncOutbox)
          ..where((entry) => entry.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _outboxSale(row);
  }

  @override
  Future<void> recoverOrphanedSyncing(DateTime now) async {
    await (_database.update(_database.syncOutbox)
          ..where(
            (entry) =>
                entry.status.equals('syncing') &
                (entry.operationType.equals(createOperation) |
                    entry.operationType.equals(confirmOperation)),
          ))
        .write(
          SyncOutboxCompanion(
            status: const Value('pending'),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<OutboxSale?> claimNextEligible(DateTime now) {
    return _database.transaction(() async {
      while (true) {
        final query = _database.select(_database.syncOutbox)
          ..where(
            (entry) =>
                (entry.operationType.equals(createOperation) |
                    entry.operationType.equals(confirmOperation)) &
                (entry.status.equals('pending') |
                    (entry.status.equals('failed_retryable') &
                        (entry.nextAttemptAt.isNull() |
                            entry.nextAttemptAt.isSmallerOrEqualValue(now)))),
          )
          ..orderBy([
            (entry) => OrderingTerm.asc(entry.createdAt),
            (entry) => OrderingTerm.asc(entry.id),
          ])
          ..limit(1);
        final row = await query.getSingleOrNull();
        if (row == null) return null;
        try {
          _outboxSale(row);
        } on FormatException {
          await (_database.update(_database.syncOutbox)
                ..where((entry) => entry.id.equals(row.id)))
              .write(
                SyncOutboxCompanion(
                  status: const Value('failed_permanent'),
                  lastError: const Value('invalid_persisted_payload'),
                  confirmationToken: const Value(null),
                  updatedAt: Value(now),
                ),
              );
          continue;
        }
        await (_database.update(_database.syncOutbox)
              ..where((entry) => entry.id.equals(row.id)))
            .write(
              SyncOutboxCompanion(
                status: const Value('syncing'),
                updatedAt: Value(now),
              ),
            );
        return read(row.id);
      }
    });
  }

  @override
  Future<bool> queueForConfirmation(
    String id, {
    required int expectedProposalRevision,
    required DateTime now,
  }) {
    return _database.transaction(() async {
      final changed = await (_database.update(_database.syncOutbox)
            ..where(
              (entry) =>
                  entry.id.equals(id) &
                  entry.status.equals('requires_acceptance') &
                  entry.proposalRevision.equals(expectedProposalRevision) &
                  entry.remoteIntentId.isNotNull() &
                  entry.confirmationToken.isNotNull(),
            ))
          .write(
            SyncOutboxCompanion(
              operationType: const Value(confirmOperation),
              status: const Value('pending'),
              updatedAt: Value(now),
            ),
          );
      return changed == 1;
    });
  }

  @override
  Future<void> markSyncing(String id, DateTime now) => _update(
    id,
    SyncOutboxCompanion(
      status: const Value('syncing'),
      updatedAt: Value(now),
    ),
  );

  @override
  Future<void> markPending(
    String id, {
    String? error,
    required DateTime now,
  }) => _update(
    id,
    SyncOutboxCompanion(
      status: const Value('pending'),
      lastError: Value(error),
      nextAttemptAt: const Value(null),
      updatedAt: Value(now),
    ),
  );

  @override
  Future<void> markConfirmed(
    String id, {
    required DateTime now,
    String? remoteIntentId,
    String? remoteSaleId,
  }) => _update(
    id,
    SyncOutboxCompanion(
      status: const Value('confirmed'),
      remoteIntentId: remoteIntentId == null
          ? const Value.absent()
          : Value(remoteIntentId),
      remoteSaleId: remoteSaleId == null
          ? const Value.absent()
          : Value(remoteSaleId),
      confirmationToken: const Value(null),
      nextAttemptAt: const Value(null),
      lastError: const Value(null),
      updatedAt: Value(now),
    ),
  );

  @override
  Future<void> markRetryable(
    String id, {
    required int attempts,
    required DateTime nextAttemptAt,
    required String error,
    required DateTime now,
  }) => _update(
    id,
    SyncOutboxCompanion(
      status: const Value('failed_retryable'),
      attempts: Value(attempts),
      nextAttemptAt: Value(nextAttemptAt),
      lastError: Value(error),
      updatedAt: Value(now),
    ),
  );

  @override
  Future<void> markPermanent(
    String id, {
    required String error,
    required DateTime now,
  }) => _update(
    id,
    SyncOutboxCompanion(
      status: const Value('failed_permanent'),
      lastError: Value(error),
      nextAttemptAt: const Value(null),
      confirmationToken: const Value(null),
      updatedAt: Value(now),
    ),
  );

  @override
  Future<void> markBlocked(
    String id, {
    required String error,
    required DateTime now,
  }) => _update(
    id,
    SyncOutboxCompanion(
      status: const Value('failed_permanent'),
      lastError: Value(error),
      nextAttemptAt: const Value(null),
      updatedAt: Value(now),
    ),
  );

  @override
  Future<void> markCancelled(String id, DateTime now) => _update(
    id,
    SyncOutboxCompanion(
      status: const Value('cancelled'),
      nextAttemptAt: const Value(null),
      confirmationToken: const Value(null),
      updatedAt: Value(now),
    ),
  );

  @override
  Future<void> markRequiresAcceptance(
    String id, {
    required String? remoteIntentId,
    required String? proposalJson,
    required String? confirmationToken,
    required DateTime now,
  }) async {
    final current = await read(id);
    await _update(
      id,
      SyncOutboxCompanion(
        operationType: const Value(createOperation),
        status: const Value('requires_acceptance'),
        remoteIntentId: remoteIntentId == null
            ? const Value.absent()
            : Value(remoteIntentId),
        proposalJson: Value(proposalJson),
        proposalRevision: Value((current?.proposalRevision ?? 0) + 1),
        confirmationToken: Value(confirmationToken),
        nextAttemptAt: const Value(null),
        lastError: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> _update(String id, SyncOutboxCompanion values) async {
    await (_database.update(_database.syncOutbox)
          ..where((entry) => entry.id.equals(id)))
        .write(values);
  }

  Stream<List<PersistedSaleSummary>> watchSalesSummary() {
    final query = _database.select(_database.localSalesTable).join([
      leftOuterJoin(
        _database.syncOutbox,
        _database.syncOutbox.id.equalsExp(_database.localSalesTable.id),
      ),
    ])
      ..orderBy([
        OrderingTerm.desc(_database.localSalesTable.createdAt),
      ]);

    return query.watch().asyncMap((rows) async {
      final summaries = <PersistedSaleSummary>[];
      for (final row in rows) {
        final sale = row.readTable(_database.localSalesTable);
        final outbox = row.readTableOrNull(_database.syncOutbox);

        final items = await (_database.select(_database.localSaleItemsTable)
              ..where((item) => item.saleId.equals(sale.id)))
            .get();

        double? total;
        if (items.any((item) => item.historicalUnitPrice != null)) {
          total = items.fold<double>(
            0.0,
            (sum, item) => sum + ((item.historicalUnitPrice ?? 0.0) * item.quantity),
          );
        }

        final status = outbox != null
            ? SaleSyncStatusValue.parse(outbox.status)
            : SaleSyncStatus.pending;

        summaries.add(
          PersistedSaleSummary(
            localSaleId: sale.id,
            clientRequestId: sale.clientRequestId,
            clientId: sale.clientId,
            clientName: sale.clientName,
            soldAt: sale.soldAt,
            createdAt: sale.createdAt,
            status: status,
            itemCount: items.length,
            totalAmount: total,
            lastError: outbox?.lastError,
          ),
        );
      }
      return summaries;
    });
  }

  OutboxSale _outboxSale(SyncOutboxData row) {
    final payload = _decodePayload(row.payloadJson, row.payloadVersion);
    if (row.clientRequestId == null ||
        row.clientRequestId != payload.clientRequestId ||
        row.localOperationId == null) {
      throw const FormatException('Identidade persistida da outbox inválida.');
    }
    return OutboxSale(
      id: row.id,
      localSaleId: row.localOperationId!,
      clientRequestId: row.clientRequestId!,
      payload: payload,
      status: SaleSyncStatusValue.parse(row.status),
      attempts: row.attempts,
      operation: row.operationType == confirmOperation
          ? SaleOutboxOperation.confirmIntent
          : SaleOutboxOperation.createIntent,
      nextAttemptAt: row.nextAttemptAt,
      remoteIntentId: row.remoteIntentId,
      confirmationToken: row.confirmationToken,
      proposalRevision: row.proposalRevision,
    );
  }
}

int _positiveRemoteId(String value, String field) {
  final parsed = int.tryParse(value);
  if (parsed == null || parsed <= 0) {
    throw SaleRegistrationException(
      'invalid_remote_id',
      '$field precisa ser um identificador numérico positivo.',
    );
  }
  return parsed;
}

final _uuidPattern = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-'
  r'[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
);

String _encodePayload(SaleIntentPayload payload) => jsonEncode({
  'payload_version': SaleIntentPayload.version,
  'client_request_id': payload.clientRequestId,
  'client_id': payload.clientId,
  'status': 'paid',
  'sold_at': payload.soldAt,
  'timezone': payload.timezone,
  'items': [
    for (final item in payload.items)
      {'product_id': item.productId, 'quantity': item.quantity},
  ],
});

SaleIntentPayload _decodePayload(String value, int version) {
  if (version != SaleIntentPayload.version) {
    throw FormatException('Versão de payload não suportada: $version');
  }
  final json = jsonDecode(value);
  if (json is! Map<String, dynamic> ||
      json['payload_version'] != version ||
      json['client_request_id'] is! String ||
      json['client_id'] is! int ||
      json['sold_at'] is! String ||
      json['timezone'] is! String ||
      json['items'] is! List) {
    throw const FormatException('Payload persistido inválido.');
  }
  final items = <SaleIntentItem>[];
  for (final value in json['items'] as List) {
    if (value is! Map ||
        value['product_id'] is! int ||
        value['quantity'] is! int ||
        (value['quantity'] as int) <= 0) {
      throw const FormatException('Item persistido inválido.');
    }
    items.add(
      SaleIntentItem(
        productId: value['product_id'] as int,
        quantity: value['quantity'] as int,
      ),
    );
  }
  if (items.isEmpty) {
    throw const FormatException('Payload persistido sem itens.');
  }
  return SaleIntentPayload(
    clientRequestId: json['client_request_id'] as String,
    clientId: json['client_id'] as int,
    soldAt: json['sold_at'] as String,
    timezone: json['timezone'] as String,
    items: items,
  );
}

String _iso8601WithOffset(DateTime value) {
  String two(int number) => number.toString().padLeft(2, '0');
  String three(int number) => number.toString().padLeft(3, '0');
  final offset = value.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final absoluteMinutes = offset.inMinutes.abs();
  final offsetText = '$sign${two(absoluteMinutes ~/ 60)}:'
      '${two(absoluteMinutes % 60)}';
  return '${value.year.toString().padLeft(4, '0')}-'
      '${two(value.month)}-${two(value.day)}T'
      '${two(value.hour)}:${two(value.minute)}:${two(value.second)}.'
      '${three(value.millisecond)}$offsetText';
}
