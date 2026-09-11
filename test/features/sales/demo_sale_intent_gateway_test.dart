import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/sales/data/demo/demo_sale_intent_gateway.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';

void main() {
  test('gateway demo confirma deterministicamente sem HTTP', () async {
    final gateway = DemoSaleIntentGateway();
    final outcome = await gateway.createIntent(
      SaleIntentPayload(
        clientRequestId: '11111111-2222-4333-8444-555555555555',
        clientId: 201,
        soldAt: '2026-09-11T09:00:00-03:00',
        timezone: 'America/Sao_Paulo',
        items: const [SaleIntentItem(productId: 101, quantity: 1)],
      ),
    );
    expect(outcome.kind, SaleIntentOutcomeKind.confirmed);
    expect(outcome.remoteIntentId, 'demo-intent-11111111');
    expect(outcome.remoteSaleId, 'demo-sale-11111111');
  });
}
