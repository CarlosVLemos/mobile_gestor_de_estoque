import '../../domain/entities/sale_sync.dart';
import '../../domain/repositories/sales_repository.dart';

/// A deterministic gateway for demo mode that processes sale intents locally
/// without making any HTTP requests or importing Dio.
class DemoSaleIntentGateway implements SaleIntentGateway {
  bool _cancelled = false;

  @override
  Future<SaleIntentOutcome> createIntent(SaleIntentPayload payload) async {
    if (_cancelled) {
      _cancelled = false;
      return const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.interrupted,
        message: 'Operação cancelada.',
      );
    }

    final id = payload.clientRequestId.length >= 8
        ? payload.clientRequestId.substring(0, 8)
        : payload.clientRequestId;

    return SaleIntentOutcome(
      kind: SaleIntentOutcomeKind.confirmed,
      remoteIntentId: 'demo-intent-$id',
      remoteSaleId: 'demo-sale-$id',
    );
  }

  @override
  Future<SaleIntentOutcome> confirmIntent({
    required String intentId,
    required String confirmationToken,
  }) async {
    if (_cancelled) {
      _cancelled = false;
      return const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.interrupted,
        message: 'Operação cancelada.',
      );
    }

    return SaleIntentOutcome(
      kind: SaleIntentOutcomeKind.confirmed,
      remoteIntentId: intentId,
      remoteSaleId: 'demo-sale-confirmed',
    );
  }

  @override
  void cancelPendingRequest() {
    _cancelled = true;
  }
}
