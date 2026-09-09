import 'dart:math';

import '../../../core/sync/outbox_drainer.dart';
import '../domain/entities/sale_sync.dart';
import '../domain/repositories/sales_repository.dart';

typedef OutboxClock = DateTime Function();
typedef OutboxJitter = int Function();

class OutboxProcessor implements OutboxDrainer {
  OutboxProcessor({
    required SaleOutboxStore store,
    required SaleIntentGateway gateway,
    OutboxClock? clock,
    OutboxJitter? jitter,
  }) : _store = store,
       _gateway = gateway,
       _clock = clock ?? DateTime.now,
       _jitter = jitter ?? _defaultJitter;

  final SaleOutboxStore _store;
  final SaleIntentGateway _gateway;
  final OutboxClock _clock;
  final OutboxJitter _jitter;
  bool _running = false;
  int _cancelGeneration = 0;

  @override
  void cancel() {
    _cancelGeneration++;
    _gateway.cancelPendingRequest();
  }

  @override
  Future<void> drain({required OutboxWriteGuard protect}) async {
    if (_running) return;
    _running = true;
    final generation = _cancelGeneration;
    try {
      await protect(() => _store.recoverOrphanedSyncing(_clock()));
      while (generation == _cancelGeneration) {
        OutboxSale? item;
        await protect(() async {
          item = await _store.claimNextEligible(_clock());
        });
        if (item == null) return;
        final claimed = item!;
        final outcome = claimed.operation == SaleOutboxOperation.confirmIntent
            ? await _confirm(claimed)
            : await _gateway.createIntent(claimed.payload);
        await _apply(claimed, outcome, protect: protect);
        if (generation != _cancelGeneration ||
            outcome.kind == SaleIntentOutcomeKind.unauthorized ||
            outcome.kind == SaleIntentOutcomeKind.retryableFailure ||
            outcome.kind == SaleIntentOutcomeKind.blocked) {
          return;
        }
      }
    } finally {
      _running = false;
    }
  }

  Future<SaleIntentOutcome> _confirm(OutboxSale item) async {
    final intentId = item.remoteIntentId;
    final token = item.confirmationToken;
    if (intentId == null || token == null) {
      return const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.permanentFailure,
        code: 'confirmation_data_missing',
      );
    }
    return _gateway.confirmIntent(
      intentId: intentId,
      confirmationToken: token,
    );
  }

  Future<void> accept(
    String outboxId, {
    required int expectedProposalRevision,
  }) async {
    final now = _clock();
    final queued = await _store.queueForConfirmation(
      outboxId,
      expectedProposalRevision: expectedProposalRevision,
      now: now,
    );
    if (!queued) {
      throw StateError('A proposta mudou ou não está aguardando aceite.');
    }
  }

  Future<void> _apply(
    OutboxSale item,
    SaleIntentOutcome outcome, {
    OutboxWriteGuard? protect,
  }) async {
    final now = _clock();
    Future<void> write(Future<void> Function() operation) =>
        protect == null ? operation() : protect(operation);
    switch (outcome.kind) {
      case SaleIntentOutcomeKind.confirmed:
        await write(() => _store.markConfirmed(
          item.id,
          now: now,
          remoteIntentId: outcome.remoteIntentId,
          remoteSaleId: outcome.remoteSaleId,
        ));
      case SaleIntentOutcomeKind.requiresAcceptance:
        await write(() => _store.markRequiresAcceptance(
          item.id,
          remoteIntentId: outcome.remoteIntentId ?? item.remoteIntentId,
          proposalJson: outcome.proposalJson,
          confirmationToken: outcome.confirmationToken,
          now: now,
        ));
      case SaleIntentOutcomeKind.retryableFailure:
        final attempts = item.attempts + 1;
        await write(() => _store.markRetryable(
          item.id,
          attempts: attempts,
          nextAttemptAt: nextAttemptAt(now, attempts, _jitter()),
          error: outcome.code ?? 'temporary_failure',
          now: now,
        ));
      case SaleIntentOutcomeKind.permanentFailure:
      case SaleIntentOutcomeKind.blocked:
        await write(() => _store.markPermanent(
          item.id,
          error: outcome.code ?? 'permanent_failure',
          now: now,
        ));
      case SaleIntentOutcomeKind.unauthorized:
        await write(() => _store.markPending(
          item.id,
          error: outcome.code ?? 'unauthorized',
          now: now,
        ));
    }
  }

  static DateTime nextAttemptAt(DateTime now, int attempts, int jitterSeconds) {
    final exponent = attempts.clamp(0, 30);
    final base = min(pow(2, exponent).toInt() * 30, 1800);
    final jitter = jitterSeconds.clamp(-15, 15);
    final candidate = now.add(Duration(seconds: base + jitter));
    return candidate.isBefore(now) ? now : candidate;
  }

  static int _defaultJitter() => Random.secure().nextInt(31) - 15;
}
