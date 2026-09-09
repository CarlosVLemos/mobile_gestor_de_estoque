import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/features/sales/data/repositories/drift_sales_repository.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';

void main() {
  late AppDatabase database;
  late DriftSalesRepository repository;
  final now = DateTime.parse('2026-09-09T12:00:00-03:00');

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftSalesRepository(database);
  });
  tearDown(() => database.close());

  SaleDraft draft({String clientId = '123', String productId = '456'}) =>
      SaleDraft(
        clientId: clientId,
        clientName: 'Cliente histórico',
        soldAt: now,
        timezone: 'America/Sao_Paulo',
        items: [
          SaleDraftItem(
            productId: productId,
            productName: 'Produto histórico',
            productSku: 'SKU-456',
            quantity: 2,
            historicalUnitPrice: 19.9,
          ),
        ],
      );

  test('persiste venda, itens e outbox atomicamente com payload v1', () async {
    const id = '11111111-2222-4333-8444-555555555555';
    await repository.register(
      localSaleId: id,
      clientRequestId: id,
      draft: draft(),
      createdAt: now,
    );

    expect(await database.select(database.localSalesTable).get(), hasLength(1));
    expect(
      (await database.select(database.localSaleItemsTable).getSingle())
          .productName,
      'Produto histórico',
    );
    final outbox = await repository.read(id);
    expect(outbox?.clientRequestId, id);
    expect(outbox?.payload.clientId, 123);
    expect(outbox?.payload.items.single.productId, 456);
    expect(outbox?.payload.items.single.quantity, 2);
    expect(outbox?.payload.soldAt, matches(RegExp(r'[+-]\d{2}:\d{2}$')));
  });

  test('rejeita IDs de fixture antes de persistir qualquer linha', () async {
    await expectLater(
      repository.register(
        localSaleId: 'sale',
        clientRequestId: '11111111-2222-4333-8444-555555555555',
        draft: draft(clientId: 'client-1', productId: 'prod-1'),
        createdAt: now,
      ),
      throwsA(
        isA<SaleRegistrationException>().having(
          (error) => error.code,
          'code',
          'invalid_remote_id',
        ),
      ),
    );
    expect(await database.select(database.localSalesTable).get(), isEmpty);
    expect(await database.select(database.localSaleItemsTable).get(), isEmpty);
    expect(await database.select(database.syncOutbox).get(), isEmpty);
  });

  test('falha na outbox faz rollback da venda e dos itens', () async {
    await database.customStatement('''
      CREATE TRIGGER reject_sale_outbox BEFORE INSERT ON sync_outbox
      BEGIN SELECT RAISE(ABORT, 'outbox failure'); END
    ''');

    await expectLater(
      repository.register(
        localSaleId: 'sale',
        clientRequestId: '11111111-2222-4333-8444-555555555555',
        draft: draft(),
        createdAt: now,
      ),
      throwsA(isA<Object>()),
    );
    expect(await database.select(database.localSalesTable).get(), isEmpty);
    expect(await database.select(database.localSaleItemsTable).get(), isEmpty);
    expect(await database.select(database.syncOutbox).get(), isEmpty);
  });

  test('recupera syncing sem trocar identidade, payload ou operação', () async {
    const id = '11111111-2222-4333-8444-555555555555';
    await repository.register(
      localSaleId: id,
      clientRequestId: id,
      draft: draft(),
      createdAt: now,
    );
    await repository.markSyncing(id, now);
    final before = await repository.read(id);

    await repository.recoverOrphanedSyncing(now.add(const Duration(minutes: 3)));
    final recovered = await repository.read(id);

    expect(recovered?.status, SaleSyncStatus.pending);
    expect(recovered?.clientRequestId, before?.clientRequestId);
    expect(recovered?.payload.soldAt, before?.payload.soldAt);
    expect(recovered?.operation, before?.operation);
  });

  test('retry preserva client_request_id e payload semântico', () async {
    const id = 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee';
    await repository.register(
      localSaleId: id,
      clientRequestId: id,
      draft: draft(),
      createdAt: now,
    );
    final before = await repository.read(id);
    await repository.markRetryable(
      id,
      attempts: 1,
      nextAttemptAt: now.add(const Duration(minutes: 1)),
      error: 'timeout',
      now: now,
    );
    final after = await repository.read(id);

    expect(after?.clientRequestId, before?.clientRequestId);
    expect(after?.payload.clientId, before?.payload.clientId);
    expect(after?.payload.soldAt, before?.payload.soldAt);
    expect(after?.payload.items.single.productId, before?.payload.items.single.productId);
  });

  test('seleciona elegíveis mais antigos primeiro e respeita next_attempt_at', () async {
    await repository.register(
      localSaleId: 'older',
      clientRequestId: '11111111-2222-4333-8444-555555555555',
      draft: draft(),
      createdAt: now,
    );
    await repository.register(
      localSaleId: 'newer',
      clientRequestId: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee',
      draft: draft(),
      createdAt: now.add(const Duration(seconds: 1)),
    );
    await repository.markRetryable(
      'older',
      attempts: 1,
      nextAttemptAt: now.add(const Duration(minutes: 1)),
      error: 'timeout',
      now: now,
    );

    final newer = await repository.claimNextEligible(now);
    expect(newer?.id, 'newer');
    expect(newer?.status, SaleSyncStatus.syncing);
    expect((await repository.read('newer'))?.status, SaleSyncStatus.syncing);

    final older = await repository.claimNextEligible(
      now.add(const Duration(minutes: 1)),
    );
    expect(older?.id, 'older');
    expect(older?.status, SaleSyncStatus.syncing);
    expect((await repository.read('older'))?.status, SaleSyncStatus.syncing);
  });

  test('payload corrompido vira permanente e não bloqueia o próximo', () async {
    const bad = '11111111-2222-4333-8444-555555555555';
    const good = 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee';
    await repository.register(
      localSaleId: 'bad',
      clientRequestId: bad,
      draft: draft(),
      createdAt: now,
    );
    await repository.register(
      localSaleId: 'good',
      clientRequestId: good,
      draft: draft(),
      createdAt: now.add(const Duration(seconds: 1)),
    );
    await database.customStatement(
      "UPDATE sync_outbox SET payload_json = '{invalid' WHERE id = 'bad'",
    );

    expect((await repository.claimNextEligible(now))?.id, 'good');
    final invalid = await (database.select(database.syncOutbox)
          ..where((row) => row.id.equals('bad')))
        .getSingle();
    expect(invalid.status, 'failed_permanent');
    expect(invalid.lastError, 'invalid_persisted_payload');
  });

  test('aceite usa CAS de revisão e preserva intent em confirmação terminal', () async {
    const id = '11111111-2222-4333-8444-555555555555';
    await repository.register(
      localSaleId: id,
      clientRequestId: id,
      draft: draft(),
      createdAt: now,
    );
    await repository.markRequiresAcceptance(
      id,
      remoteIntentId: 'intent-1',
      proposalJson: '{"version":1}',
      confirmationToken: 'secret',
      now: now,
    );

    expect(
      await repository.queueForConfirmation(
        id,
        expectedProposalRevision: 0,
        now: now,
      ),
      isFalse,
    );
    expect(
      await repository.queueForConfirmation(
        id,
        expectedProposalRevision: 1,
        now: now,
      ),
      isTrue,
    );
    final queued = await repository.read(id);
    expect(queued?.operation, SaleOutboxOperation.confirmIntent);
    expect(queued?.status, SaleSyncStatus.pending);

    await repository.markConfirmed(id, now: now);
    final terminal = await repository.read(id);
    expect(terminal?.remoteIntentId, 'intent-1');
    expect(terminal?.confirmationToken, isNull);
  });

  test('403 bloqueia sem apagar token, identidade, payload ou operação', () async {
    const id = '11111111-2222-4333-8444-555555555555';
    await repository.register(
      localSaleId: id,
      clientRequestId: id,
      draft: draft(),
      createdAt: now,
    );
    await repository.markRequiresAcceptance(
      id,
      remoteIntentId: 'intent-1',
      proposalJson: '{"version":1}',
      confirmationToken: 'secret',
      now: now,
    );
    await repository.queueForConfirmation(
      id,
      expectedProposalRevision: 1,
      now: now,
    );
    final before = await repository.claimNextEligible(now);

    await repository.markBlocked(id, error: 'forbidden', now: now);
    final blocked = await repository.read(id);

    expect(blocked?.status, SaleSyncStatus.failedPermanent);
    expect(blocked?.clientRequestId, before?.clientRequestId);
    expect(blocked?.payload.clientId, before?.payload.clientId);
    expect(blocked?.payload.soldAt, before?.payload.soldAt);
    expect(
      blocked?.payload.items.single.productId,
      before?.payload.items.single.productId,
    );
    expect(blocked?.operation, SaleOutboxOperation.confirmIntent);
    expect(blocked?.remoteIntentId, 'intent-1');
    expect(blocked?.confirmationToken, 'secret');
    expect(blocked?.attempts, 0);
    final persisted = await (database.select(database.syncOutbox)
          ..where((row) => row.id.equals(id)))
        .getSingle();
    expect(persisted.proposalJson, '{"version":1}');
  });

  test('cancelamento controlado devolve para pending sem alterar a operação', () async {
    const id = '11111111-2222-4333-8444-555555555555';
    await repository.register(
      localSaleId: id,
      clientRequestId: id,
      draft: draft(),
      createdAt: now,
    );
    final claimed = await repository.claimNextEligible(now);

    await repository.markPending(id, now: now);
    final resumed = await repository.read(id);

    expect(resumed?.status, SaleSyncStatus.pending);
    expect(resumed?.attempts, claimed?.attempts);
    expect(resumed?.nextAttemptAt, isNull);
    expect(resumed?.clientRequestId, claimed?.clientRequestId);
    expect(resumed?.payload.clientId, claimed?.payload.clientId);
    expect(resumed?.payload.soldAt, claimed?.payload.soldAt);
    expect(resumed?.operation, claimed?.operation);
    final persisted = await (database.select(database.syncOutbox)
          ..where((row) => row.id.equals(id)))
        .getSingle();
    expect(persisted.lastError, isNull);
  });

  test('restart recupera syncing com a mesma identidade, payload e operação', () async {
    final directory = await Directory.systemTemp.createTemp('sale-restart-');
    final file = File('${directory.path}${Platform.pathSeparator}context.db');
    const id = '11111111-2222-4333-8444-555555555555';
    var fileDatabase = AppDatabase(NativeDatabase(file));
    var fileRepository = DriftSalesRepository(fileDatabase);
    try {
      await fileRepository.register(
        localSaleId: id,
        clientRequestId: id,
        draft: draft(),
        createdAt: now,
      );
      await fileRepository.markSyncing(id, now);
      final before = await fileRepository.read(id);
      await fileDatabase.close();

      fileDatabase = AppDatabase(NativeDatabase(file));
      fileRepository = DriftSalesRepository(fileDatabase);
      await fileRepository.recoverOrphanedSyncing(
        now.add(const Duration(minutes: 3)),
      );
      final recovered = await fileRepository.read(id);

      expect(recovered?.status, SaleSyncStatus.pending);
      expect(recovered?.clientRequestId, before?.clientRequestId);
      expect(recovered?.payload.soldAt, before?.payload.soldAt);
      expect(recovered?.operation, before?.operation);
    } finally {
      await fileDatabase.close();
      await directory.delete(recursive: true);
    }
  });
}
