import '../../domain/entities/sale_sync.dart';
import '../../domain/repositories/sales_repository.dart';

class DemoSaleIntentGateway implements SaleIntentGateway {
  bool _cancelled = false;

  @override
  Future<SaleIntentOutcome> createIntent(SaleIntentPayload payload) async {
    if (_takeCancellation()) {
      return const SaleIntentOutcome(kind: SaleIntentOutcomeKind.interrupted);
    }
    final suffix = payload.clientRequestId.substring(0, 8);
    return SaleIntentOutcome(
      kind: SaleIntentOutcomeKind.confirmed,
      remoteIntentId: 'demo-intent-$suffix',
      remoteSaleId: 'demo-sale-$suffix',
    );
  }

  @override
  Future<SaleIntentOutcome> confirmIntent({
    required String intentId,
    required String confirmationToken,
  }) async {
    if (_takeCancellation()) {
      return const SaleIntentOutcome(kind: SaleIntentOutcomeKind.interrupted);
    }
    return SaleIntentOutcome(
      kind: SaleIntentOutcomeKind.confirmed,
      remoteIntentId: intentId,
      remoteSaleId: 'demo-sale-confirmed',
    );
  }

  bool _takeCancellation() {
    final value = _cancelled;
    _cancelled = false;
    return value;
  }

  @override
  void cancelPendingRequest() => _cancelled = true;
}
