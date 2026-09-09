import '../entities/sale_sync.dart';

abstract interface class SalesRepository {
  Future<String> register({
    required String localSaleId,
    required String clientRequestId,
    required SaleDraft draft,
    required DateTime createdAt,
  });
}

abstract interface class SaleOutboxStore {
  Future<OutboxSale?> read(String id);
  Future<bool> queueForConfirmation(
    String id, {
    required int expectedProposalRevision,
    required DateTime now,
  });
  Future<void> recoverOrphanedSyncing(DateTime now);
  Future<OutboxSale?> claimNextEligible(DateTime now);
  Future<void> markSyncing(String id, DateTime now);
  Future<void> markPending(
    String id, {
    required String error,
    required DateTime now,
  });
  Future<void> markConfirmed(
    String id, {
    required DateTime now,
    String? remoteIntentId,
    String? remoteSaleId,
  });
  Future<void> markRetryable(
    String id, {
    required int attempts,
    required DateTime nextAttemptAt,
    required String error,
    required DateTime now,
  });
  Future<void> markPermanent(
    String id, {
    required String error,
    required DateTime now,
  });
  Future<void> markCancelled(String id, DateTime now);
  Future<void> markRequiresAcceptance(
    String id, {
    required String? remoteIntentId,
    required String? proposalJson,
    required String? confirmationToken,
    required DateTime now,
  });
}

abstract interface class SaleIntentGateway {
  Future<SaleIntentOutcome> createIntent(SaleIntentPayload payload);
  Future<SaleIntentOutcome> confirmIntent({
    required String intentId,
    required String confirmationToken,
  });
  void cancelPendingRequest();
}
