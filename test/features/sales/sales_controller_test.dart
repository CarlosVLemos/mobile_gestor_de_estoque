import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/local_context_lifecycle.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/features/sales/application/use_cases/register_sale_use_case.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_reference_data.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';
import 'package:gestor_de_estoque/features/sales/domain/repositories/sales_repository.dart';
import 'package:gestor_de_estoque/features/sales/presentation/controllers/sales_controller.dart';
import 'package:gestor_de_estoque/features/sales/sales_providers.dart';

void main() {
  const client = SaleClientOption(
    id: '201',
    name: 'Cliente',
    code: 'CLI-201',
    city: 'Belém - PA',
  );
  const product = SaleProductOption(
    id: '101',
    name: 'Produto',
    sku: 'SKU-101',
    price: 12.5,
  );
  final seed = SalesDraftSeed(
    clients: const [client],
    products: const [product],
  );

  ProviderContainer createContainer(
    _SalesRepository repository, {
    String? timezone = 'America/Belem',
  }) {
    final useCase = RegisterSaleUseCase(
      repository: repository,
      idGenerator: () => '11111111-2222-4333-8444-555555555555',
      clock: () => DateTime(2026, 9, 11, 9),
    );
    final container = ProviderContainer(
      overrides: [
        salesDraftSeedProvider.overrideWith((ref) => Stream.value(seed)),
        registerSaleUseCaseProvider.overrideWithValue(useCase),
        salesTimeZoneProvider.overrideWithValue(timezone),
        contextSyncEngineProvider.overrideWithValue(null),
        shellProfileProvider.overrideWithValue(_profile),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<SalesController> ready(ProviderContainer container) async {
    final stateReady = Completer<void>();
    final subscription = container.listen(
      salesControllerProvider,
      (_, state) {
        final referenceFailure = state.referenceFailure;
        if (referenceFailure != null && !stateReady.isCompleted) {
          stateReady.completeError(StateError(referenceFailure));
        } else if (state.clients.isNotEmpty &&
            state.products.isNotEmpty &&
            !stateReady.isCompleted) {
          stateReady.complete();
        }
      },
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    final controller = container.read(salesControllerProvider.notifier);
    await stateReady.future;
    return controller;
  }

  test(
    'consome referências locais e mantém carrinho transitório imutável',
    () async {
      final container = createContainer(_SalesRepository());
      final controller = await ready(container);
      expect(container.read(salesControllerProvider).clients, [client]);
      expect(container.read(salesControllerProvider).products, [product]);
      controller.addProduct(product);
      controller.addProduct(product);
      expect(
        container.read(salesControllerProvider).cartItems['101']?.quantity,
        2,
      );
      expect(
        () => container.read(salesControllerProvider).cartItems.remove('101'),
        throwsUnsupportedError,
      );
    },
  );

  test(
    'registra pelo use case persistente com IDs reais e limpa formulário',
    () async {
      final repository = _SalesRepository();
      final container = createContainer(repository);
      final controller = await ready(container);
      controller.selectClient(client);
      controller.addProduct(product);
      final id = await controller.registerSale();
      expect(id, '11111111-2222-4333-8444-555555555555');
      expect(repository.draft?.clientId, '201');
      expect(repository.draft?.items.single.productId, '101');
      expect(repository.draft?.timezone, 'America/Belem');
      expect(container.read(salesControllerProvider).selectedClient, isNull);
      expect(container.read(salesControllerProvider).cartItems, isEmpty);
    },
  );

  test('falha fechado sem timezone IANA', () async {
    final container = createContainer(_SalesRepository(), timezone: null);
    final controller = await ready(container);
    controller.selectClient(client);
    controller.addProduct(product);
    await expectLater(
      controller.registerSale(),
      throwsA(isA<SaleRegistrationException>()),
    );
  });

  test('gerador padrão produz UUID v4', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(
      container.read(salesIdGeneratorProvider)(),
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });
}

class _SalesRepository implements SalesRepository {
  SaleDraft? draft;

  @override
  Future<String> register({
    required String localSaleId,
    required String clientRequestId,
    required SaleDraft draft,
    required DateTime createdAt,
  }) async {
    this.draft = draft;
    return localSaleId;
  }
}

final _profile = ShellProfile(
  userName: 'Maria',
  userEmail: 'maria@example.test',
  tenantName: 'Arara',
  tenantSlug: 'arara',
  features: const {'sales'},
  permissions: const {'sales_create': true, 'view_financial_metrics': true},
);
