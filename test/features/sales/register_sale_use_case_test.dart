import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/sales/application/use_cases/register_sale_use_case.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';
import 'package:gestor_de_estoque/features/sales/domain/repositories/sales_repository.dart';

void main() {
  final draft = SaleDraft(
    clientId: '1',
    clientName: 'Cliente',
    soldAt: DateTime.utc(2026, 9, 9, 15),
    timezone: 'America/Sao_Paulo',
    items: const [
      SaleDraftItem(
        productId: '2',
        productName: 'Produto',
        productSku: 'SKU',
        quantity: 1,
      ),
    ],
  );

  test('bloqueia nova venda sem feature e permissão', () async {
    final repository = _Repository();
    final useCase = RegisterSaleUseCase(
      repository: repository,
      idGenerator: () => '11111111-2222-4333-8444-555555555555',
      clock: () => DateTime.utc(2026, 9, 9),
    );

    await expectLater(
      useCase(
        draft: draft,
        access: const SaleAccess(
          hasSalesFeature: true,
          canCreateSales: false,
        ),
      ),
      throwsA(isA<SaleRegistrationException>()),
    );
    expect(repository.calls, 0);
  });

  test('gera client_request_id uma vez e o persiste como identidade local', () async {
    var generations = 0;
    final repository = _Repository();
    final useCase = RegisterSaleUseCase(
      repository: repository,
      idGenerator: () {
        generations++;
        return '11111111-2222-4333-8444-555555555555';
      },
      clock: () => DateTime.utc(2026, 9, 9),
    );

    final id = await useCase(
      draft: draft,
      access: const SaleAccess(
        hasSalesFeature: true,
        canCreateSales: true,
      ),
    );
    expect(id, '11111111-2222-4333-8444-555555555555');
    expect(generations, 1);
    expect(
      repository.clientRequestId,
      '11111111-2222-4333-8444-555555555555',
    );
  });
}

class _Repository implements SalesRepository {
  int calls = 0;
  String? clientRequestId;

  @override
  Future<String> register({
    required String localSaleId,
    required String clientRequestId,
    required SaleDraft draft,
    required DateTime createdAt,
  }) async {
    calls++;
    this.clientRequestId = clientRequestId;
    return localSaleId;
  }
}
