import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/local_context_lifecycle.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/core/database/local_context.dart';
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
    SalesRepository repository, {
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

  test('bloqueia duas chamadas e edição enquanto salva', () async {
    final repository = _SalesRepository()..pending = Completer<String>();
    final container = createContainer(repository);
    final controller = await ready(container);
    controller.selectClient(client);
    controller.addProduct(product);

    final first = controller.registerSale();
    final rejected = expectLater(controller.registerSale(), throwsStateError);
    expect(repository.calls, 1);
    controller.incrementQuantity(product.id);
    controller.removeItem(product.id);
    expect(container.read(salesControllerProvider).cartItems[product.id]?.quantity, 1);
    expect(repository.draft?.items.single.quantity, 1);
    repository.pending!.complete('11111111-2222-4333-8444-555555555555');
    await first;
    await rejected;
    expect(repository.calls, 1);
    expect(container.read(salesControllerProvider).cartItems, isEmpty);
  });

  test('mantém a venda bloqueada quando o resultado não pode ser verificado', () async {
    final repository = _SalesRepository()..pending = Completer<String>();
    final container = createContainer(repository);
    final controller = await ready(container);
    controller.selectClient(client);
    controller.addProduct(product);
    final first = controller.registerSale();
    final failure = expectLater(first, throwsStateError);
    repository.pending!.completeError(StateError('resultado desconhecido'));
    await failure;
    expect(container.read(salesControllerProvider).isSubmissionBlocked, isTrue);
    expect(container.read(salesControllerProvider).cartItems, isNotEmpty);
    await expectLater(controller.registerSale(), throwsStateError);
    expect(repository.calls, 1);
  });

  test('libera nova tentativa apenas quando ausência da outbox é verificada', () async {
    final repository = _RecoveringRepository()..pending = Completer<String>();
    final container = createContainer(repository);
    final controller = await ready(container);
    controller.selectClient(client);
    controller.addProduct(product);
    final first = controller.registerSale();
    final failure = expectLater(first, throwsStateError);
    repository.pending!.completeError(StateError('falha no registro'));
    await failure;
    expect(container.read(salesControllerProvider).isSubmissionBlocked, isFalse);
    expect(container.read(salesControllerProvider).cartItems, isNotEmpty);
    repository.pending = null;
    await controller.registerSale();
    expect(repository.calls, 2);
  });

  test('verificação posterior libera tentativa somente após consulta válida', () async {
    final repository = _RecoveringRepository()
      ..pending = Completer<String>()
      ..readUnavailable = true;
    final container = createContainer(repository);
    final controller = await ready(container);
    controller.selectClient(client);
    controller.addProduct(product);
    final first = controller.registerSale();
    final failure = expectLater(first, throwsStateError);
    repository.pending!.completeError(StateError('resultado desconhecido'));
    await failure;
    expect(await controller.reconcileSubmission(), isNull);
    expect(container.read(salesControllerProvider).isSubmissionBlocked, isTrue);
    repository.readUnavailable = false;
    expect(await controller.reconcileSubmission(), isFalse);
    expect(container.read(salesControllerProvider).isSubmissionBlocked, isFalse);
    expect(container.read(salesControllerProvider).cartItems, isNotEmpty);
  });

  test('reconcilia commit com retorno perdido sem registrar novamente', () async {
    final repository = _RecoveringRepository()
      ..pending = Completer<String>()
      ..committed = true;
    final container = createContainer(repository);
    final controller = await ready(container);
    controller.selectClient(client);
    controller.addProduct(product);
    final first = controller.registerSale();
    repository.pending!.completeError(StateError('retorno perdido'));
    expect(await first, '11111111-2222-4333-8444-555555555555');
    expect(repository.calls, 1);
    expect(container.read(salesControllerProvider).cartItems, isEmpty);
  });

  test('retorno antigo não limpa carrinho de outro contexto', () async {
    final repository = _SalesRepository()..pending = Completer<String>();
    final container = createContainer(repository);
    container.read(activeSyncContextProvider.notifier).state =
        const LocalContext(userId: '1', tenantId: '1');
    final firstController = await ready(container);
    firstController.selectClient(client);
    firstController.addProduct(product);
    final first = firstController.registerSale();

    container.read(activeSyncContextProvider.notifier).state =
        const LocalContext(userId: '2', tenantId: '2');
    final nextController = await ready(container);
    nextController.selectClient(client);
    nextController.addProduct(product);
    repository.pending!.complete('11111111-2222-4333-8444-555555555555');
    await first;
    expect(container.read(salesControllerProvider).cartItems, isNotEmpty);
    expect(container.read(salesControllerProvider).selectedClient, client);
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
  int calls = 0;
  Completer<String>? pending;

  @override
  Future<String> register({
    required String localSaleId,
    required String clientRequestId,
    required SaleDraft draft,
    required DateTime createdAt,
  }) async {
    calls++;
    this.draft = draft;
    final operation = pending;
    return operation == null ? localSaleId : await operation.future;
  }
}

class _RecoveringRepository extends _SalesRepository implements SaleOutboxStore {
  bool committed = false;
  bool readUnavailable = false;

  @override
  Future<OutboxSale?> read(String id) async {
    if (readUnavailable) throw StateError('banco indisponível');
    if (!committed) return null;
    return OutboxSale(
      id: id,
      localSaleId: id,
      clientRequestId: id,
      payload: SaleIntentPayload(
        clientRequestId: id,
        clientId: 201,
        items: const [SaleIntentItem(productId: 101, quantity: 1)],
        soldAt: '2026-09-11T09:00:00-03:00',
        timezone: 'America/Belem',
      ),
      status: SaleSyncStatus.pending,
      attempts: 0,
      operation: SaleOutboxOperation.createIntent,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _profile = ShellProfile(
  userName: 'Maria',
  userEmail: 'maria@example.test',
  tenantName: 'Arara',
  tenantSlug: 'arara',
  features: const {'sales'},
  permissions: const {'sales_create': true, 'view_financial_metrics': true},
);
