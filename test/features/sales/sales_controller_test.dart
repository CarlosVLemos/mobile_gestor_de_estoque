import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_reference_data.dart';
import 'package:gestor_de_estoque/features/sales/presentation/controllers/pending_sales_controller.dart';
import 'package:gestor_de_estoque/features/sales/presentation/controllers/sales_controller.dart';
import 'package:gestor_de_estoque/features/sales/sales_providers.dart';

void main() {
  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        salesIdGeneratorProvider.overrideWithValue(
          () => '11111111-2222-4333-8444-555555555555',
        ),
        salesClockProvider.overrideWithValue(() => DateTime(2026, 6, 18, 9, 7)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('carrega seed local e inicia sem cliente ou itens', () {
    final container = createContainer();
    final state = container.read(salesControllerProvider);

    expect(state.clients, isNotEmpty);
    expect(state.products, isNotEmpty);
    expect(state.selectedClient, isNull);
    expect(state.cartItems, isEmpty);
    expect(state.canRegister, isFalse);
  });

  test('controla quantidade sem permitir valor menor que um', () {
    final container = createContainer();
    final controller = container.read(salesControllerProvider.notifier);
    const product = SaleProductOption(
      id: 'product-1',
      name: 'Produto',
      sku: 'SKU-1',
      price: 10,
    );

    controller.addProduct(product);
    controller.addProduct(product);
    expect(
      container.read(salesControllerProvider).cartItems['product-1']?.quantity,
      2,
    );

    controller.decrementQuantity('product-1');
    controller.decrementQuantity('product-1');
    expect(
      container.read(salesControllerProvider).cartItems['product-1']?.quantity,
      1,
    );

    controller.removeItem('product-1');
    expect(container.read(salesControllerProvider).cartItems, isEmpty);
  });

  test('preco ausente mantém subtotal e total como pendentes', () {
    final container = createContainer();
    final controller = container.read(salesControllerProvider.notifier);

    controller.addProduct(
      const SaleProductOption(
        id: 'restricted',
        name: 'Produto restrito',
        sku: 'SKU-NULL',
        price: null,
      ),
    );

    final state = container.read(salesControllerProvider);
    expect(state.hasPendingPrice, isTrue);
    expect(state.cartItems['restricted']?.subtotal, isNull);
  });

  test('recusa registro sem cliente ou sem itens', () {
    final container = createContainer();
    final controller = container.read(salesControllerProvider.notifier);

    expect(controller.registerSale, throwsStateError);

    controller.selectClient(
      const SaleClientOption(
        id: 'client-1',
        name: 'Cliente',
        code: 'CLI-1',
        city: 'Belem',
      ),
    );

    expect(controller.registerSale, throwsStateError);
    expect(container.read(pendingSalesProvider), isEmpty);
  });

  test('cria rascunho determinístico, enfileira e limpa o formulário', () {
    final container = createContainer();
    final controller = container.read(salesControllerProvider.notifier);
    const client = SaleClientOption(
      id: 'client-1',
      name: 'Cliente',
      code: 'CLI-1',
      city: 'Belem',
    );
    const product = SaleProductOption(
      id: 'product-1',
      name: 'Produto',
      sku: 'SKU-1',
      price: 12.5,
    );

    controller.selectClient(client);
    controller.addProduct(product);
    controller.incrementQuantity(product.id);
    final sale = controller.registerSale();

    expect(sale.clientRequestId, '11111111-2222-4333-8444-555555555555');
    expect(sale.createdAtLabel, '09:07');
    expect(sale.client, same(client));
    expect(sale.items, hasLength(1));
    expect(sale.items.single.quantity, 2);
    expect(container.read(pendingSalesProvider), [same(sale)]);

    final state = container.read(salesControllerProvider);
    expect(state.selectedClient, isNull);
    expect(state.cartItems, isEmpty);
    expect(state.canRegister, isFalse);
  });

  test('gerador padrão produz UUID v4', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final id = container.read(salesIdGeneratorProvider)();

    expect(
      id,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-'
          r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });

  test('estado e fila não permitem mutação externa', () {
    final container = createContainer();
    final controller = container.read(salesControllerProvider.notifier);
    const client = SaleClientOption(
      id: 'client-1',
      name: 'Cliente',
      code: 'CLI-1',
      city: 'Belem',
    );
    const product = SaleProductOption(
      id: 'product-1',
      name: 'Produto',
      sku: 'SKU-1',
      price: 10,
    );

    controller.selectClient(client);
    controller.addProduct(product);
    expect(
      () => container
          .read(salesControllerProvider)
          .cartItems
          .remove(product.id),
      throwsUnsupportedError,
    );

    final sale = controller.registerSale();
    expect(() => sale.items.clear(), throwsUnsupportedError);
    expect(
      () => container.read(pendingSalesProvider).clear(),
      throwsUnsupportedError,
    );
  });
}
