import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/sales/application/outbox_processor.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';
import 'package:gestor_de_estoque/features/sales/domain/repositories/sales_repository.dart';

void main() {
  final now = DateTime.utc(2026, 9, 9, 15);
  Future<void> protect(Future<void> Function() write) => write();

  OutboxSale item(
    String id, {
    int attempts = 0,
    SaleOutboxOperation operation = SaleOutboxOperation.createIntent,
    SaleSyncStatus status = SaleSyncStatus.pending,
    int proposalRevision = 0,
    String? intentId,
    String? token,
  }) => OutboxSale(
    id: id,
    localSaleId: id,
    clientRequestId: 'request-$id',
    payload: SaleIntentPayload(
      clientRequestId: 'request-$id',
      clientId: int.parse(id),
      soldAt: '2026-09-09T12:00:00-03:00',
      timezone: 'America/Sao_Paulo',
      items: const [SaleIntentItem(productId: 10, quantity: 1)],
    ),
    status: status,
    attempts: attempts,
    operation: operation,
    proposalRevision: proposalRevision,
    remoteIntentId: intentId,
    confirmationToken: token,
  );

  test('recupera syncing e processa sequencialmente na ordem do store', () async {
    final store = _Store()..eligible.addAll([item('1'), item('2')]);
    final gateway = _Gateway()
      ..createOutcomes.addAll(const [
        SaleIntentOutcome(kind: SaleIntentOutcomeKind.confirmed),
        SaleIntentOutcome(kind: SaleIntentOutcomeKind.confirmed),
      ]);
    final processor = OutboxProcessor(
      store: store,
      gateway: gateway,
      clock: () => now,
      jitter: () => 0,
    );

    await processor.drain(protect: protect);

    expect(store.recovered, isTrue);
    expect(store.syncing, ['1', '2']);
    expect(gateway.created, ['request-1', 'request-2']);
    expect(store.confirmed, ['1', '2']);
    expect(gateway.maxConcurrent, 1);
  });

  test('retry usa attempts, backoff, jitter e payload estável', () async {
    final original = item('1');
    final store = _Store()..eligible.add(original);
    final gateway = _Gateway()
      ..createOutcomes.add(const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.retryableFailure,
        code: 'timeout',
      ));
    final processor = OutboxProcessor(
      store: store,
      gateway: gateway,
      clock: () => now,
      jitter: () => -15,
    );

    await processor.drain(protect: protect);

    expect(store.retryAttempts, 1);
    expect(store.retryAt, now.add(const Duration(seconds: 45)));
    expect(gateway.created.single, original.clientRequestId);
    expect(
      OutboxProcessor.nextAttemptAt(now, 30, -15),
      now.add(const Duration(seconds: 1785)),
    );
  });

  test('requires_acceptance nunca confirma automaticamente', () async {
    final store = _Store()..eligible.add(item('1'));
    final gateway = _Gateway()
      ..createOutcomes.add(const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.requiresAcceptance,
        remoteIntentId: 'intent-1',
        proposalJson: '{"version":1}',
        confirmationToken: 'token-1',
      ));
    final processor = OutboxProcessor(
      store: store,
      gateway: gateway,
      clock: () => now,
    );

    await processor.drain(protect: protect);

    expect(store.requiresAcceptance, 1);
    expect(gateway.confirmed, isEmpty);
  });

  test('403 bloqueia a operação e interrompe a rodada', () async {
    final blocked = item(
      '1',
      operation: SaleOutboxOperation.confirmIntent,
      intentId: 'intent-1',
      token: 'token-1',
    );
    final store = _Store()..eligible.addAll([blocked, item('2')]);
    final gateway = _Gateway()
      ..confirmOutcomes.add(const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.blocked,
        code: 'forbidden',
      ));
    final processor = OutboxProcessor(
      store: store,
      gateway: gateway,
      clock: () => now,
    );

    await processor.drain(protect: protect);

    expect(gateway.confirmed, ['intent-1:token-1']);
    expect(store.blocked, ['1']);
    expect(store.lastClaimed?.operation, SaleOutboxOperation.confirmIntent);
    expect(store.lastClaimed?.confirmationToken, 'token-1');
    expect(store.eligible.single.id, '2');
  });

  test('cancelamento de lifecycle devolve o claim sem attempts ou backoff', () async {
    final original = item(
      '1',
      attempts: 2,
      operation: SaleOutboxOperation.confirmIntent,
      intentId: 'intent-1',
      token: 'token-1',
    );
    final store = _Store()..eligible.add(original);
    final gateway = _Gateway()
      ..confirmOutcomes.add(const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.interrupted,
        code: 'request_cancelled',
      ));
    final processor = OutboxProcessor(
      store: store,
      gateway: gateway,
      clock: () => now,
    );

    await processor.drain(protect: protect);

    expect(store.pending, ['1']);
    expect(store.pendingErrors.single, isNull);
    expect(store.retryAttempts, isNull);
    expect(store.retryAt, isNull);
    expect(store.lastClaimed?.id, original.id);
    expect(store.lastClaimed?.operation, original.operation);
    expect(store.lastClaimed?.payload, same(original.payload));
    expect(store.lastClaimed?.attempts, 2);
  });

  test('aceite só enfileira confirmação e exige revisão atual', () async {
    final accepted = item(
      '1',
      operation: SaleOutboxOperation.confirmIntent,
      status: SaleSyncStatus.syncing,
      proposalRevision: 2,
      intentId: 'intent-1',
      token: 'token-2',
    );
    final store = _Store()..claimed = accepted;
    final gateway = _Gateway();
    final processor = OutboxProcessor(
      store: store,
      gateway: gateway,
      clock: () => now,
    );

    await processor.accept('1', expectedProposalRevision: 2);

    expect(store.claimedRevision, 2);
    expect(gateway.confirmed, isEmpty);
    expect(store.requiresAcceptance, 0);

    await expectLater(
      processor.accept('1', expectedProposalRevision: 1),
      throwsStateError,
    );
  });
}

class _Store implements SaleOutboxStore {
  final eligible = <OutboxSale>[];
  final syncing = <String>[];
  final confirmed = <String>[];
  bool recovered = false;
  int? retryAttempts;
  DateTime? retryAt;
  int requiresAcceptance = 0;
  final permanent = <String>[];
  final blocked = <String>[];
  final pending = <String>[];
  final pendingErrors = <String?>[];
  OutboxSale? claimed;
  OutboxSale? lastClaimed;
  int? claimedRevision;

  @override
  Future<void> recoverOrphanedSyncing(DateTime now) async => recovered = true;

  @override
  Future<OutboxSale?> claimNextEligible(DateTime now) async {
    if (eligible.isEmpty) return null;
    final item = eligible.removeAt(0);
    syncing.add(item.id);
    return lastClaimed = OutboxSale(
      id: item.id,
      localSaleId: item.localSaleId,
      clientRequestId: item.clientRequestId,
      payload: item.payload,
      status: SaleSyncStatus.syncing,
      attempts: item.attempts,
      operation: item.operation,
      nextAttemptAt: item.nextAttemptAt,
      remoteIntentId: item.remoteIntentId,
      confirmationToken: item.confirmationToken,
      proposalRevision: item.proposalRevision,
    );
  }

  @override
  Future<OutboxSale?> read(String id) async => claimed;

  @override
  Future<bool> queueForConfirmation(
    String id, {
    required int expectedProposalRevision,
    required DateTime now,
  }) async {
    claimedRevision = expectedProposalRevision;
    return claimed?.proposalRevision == expectedProposalRevision;
  }

  @override
  Future<void> markSyncing(String id, DateTime now) async => syncing.add(id);

  @override
  Future<void> markPending(
    String id, {
    String? error,
    required DateTime now,
  }) async {
    pending.add(id);
    pendingErrors.add(error);
  }

  @override
  Future<void> markConfirmed(
    String id, {
    required DateTime now,
    String? remoteIntentId,
    String? remoteSaleId,
  }) async => confirmed.add(id);

  @override
  Future<void> markRetryable(
    String id, {
    required int attempts,
    required DateTime nextAttemptAt,
    required String error,
    required DateTime now,
  }) async {
    retryAttempts = attempts;
    retryAt = nextAttemptAt;
  }

  @override
  Future<void> markPermanent(
    String id, {
    required String error,
    required DateTime now,
  }) async => permanent.add(id);

  @override
  Future<void> markBlocked(
    String id, {
    required String error,
    required DateTime now,
  }) async => blocked.add(id);

  @override
  Future<void> markCancelled(String id, DateTime now) async {}

  @override
  Future<void> markRequiresAcceptance(
    String id, {
    required String? remoteIntentId,
    required String? proposalJson,
    required String? confirmationToken,
    required DateTime now,
  }) async => requiresAcceptance++;
}

class _Gateway implements SaleIntentGateway {
  final createOutcomes = <SaleIntentOutcome>[];
  final confirmOutcomes = <SaleIntentOutcome>[];
  final created = <String>[];
  final confirmed = <String>[];
  int concurrent = 0;
  int maxConcurrent = 0;

  @override
  Future<SaleIntentOutcome> createIntent(SaleIntentPayload payload) async {
    concurrent++;
    if (concurrent > maxConcurrent) maxConcurrent = concurrent;
    created.add(payload.clientRequestId);
    final result = createOutcomes.removeAt(0);
    concurrent--;
    return result;
  }

  @override
  Future<SaleIntentOutcome> confirmIntent({
    required String intentId,
    required String confirmationToken,
  }) async {
    confirmed.add('$intentId:$confirmationToken');
    return confirmOutcomes.removeAt(0);
  }

  @override
  void cancelPendingRequest() {}
}
