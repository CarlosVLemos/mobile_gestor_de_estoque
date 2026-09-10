import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/sales/data/demo/demo_sale_intent_gateway.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';

void main() {
  group('DemoSaleIntentGateway', () {
    late DemoSaleIntentGateway gateway;

    setUp(() {
      gateway = DemoSaleIntentGateway();
    });

    test('returns confirmed outcome deterministically without HTTP', () async {
      final payload = SaleIntentPayload(
        clientRequestId: '550e8400-e29b-41d4-a716-446655440000',
        clientId: 201,
        items: const [SaleIntentItem(productId: 101, quantity: 2)],
        soldAt: '2026-09-10T12:00:00.000-03:00',
        timezone: 'America/Sao_Paulo',
      );

      final outcome = await gateway.createIntent(payload);

      expect(outcome.kind, equals(SaleIntentOutcomeKind.confirmed));
      expect(outcome.remoteIntentId, equals('demo-intent-550e8400'));
      expect(outcome.remoteSaleId, equals('demo-sale-550e8400'));
    });

    test('confirms intent deterministically', () async {
      final outcome = await gateway.confirmIntent(
        intentId: 'demo-intent-12345678',
        confirmationToken: 'demo-token',
      );

      expect(outcome.kind, equals(SaleIntentOutcomeKind.confirmed));
      expect(outcome.remoteIntentId, equals('demo-intent-12345678'));
      expect(outcome.remoteSaleId, equals('demo-sale-confirmed'));
    });

    test('handles cancelPendingRequest gracefully', () async {
      gateway.cancelPendingRequest();

      final payload = SaleIntentPayload(
        clientRequestId: '550e8400-e29b-41d4-a716-446655440000',
        clientId: 201,
        items: const [SaleIntentItem(productId: 101, quantity: 1)],
        soldAt: '2026-09-10T12:00:00.000-03:00',
        timezone: 'America/Sao_Paulo',
      );

      final outcome = await gateway.createIntent(payload);
      expect(outcome.kind, equals(SaleIntentOutcomeKind.interrupted));
    });
  });
}
