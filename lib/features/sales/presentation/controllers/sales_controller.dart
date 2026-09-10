import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/composition/local_context_composition.dart';
import '../../../../app/shell/shell_profile.dart';
import '../../../../core/config/app_mode.dart';
import '../../../../core/sync/sync_state.dart';
import '../../domain/entities/sale_reference_data.dart';
import '../../domain/entities/sale_sync.dart';
import '../../sales_providers.dart';
import '../state/sales_state.dart';

final salesControllerProvider = NotifierProvider<SalesController, SalesState>(
  SalesController.new,
);

class SalesController extends Notifier<SalesState> {
  @override
  SalesState build() {
    final appMode = ref.watch(appModeProvider);
    final seed = ref.watch(loadSalesDraftSeedUseCaseProvider).call();

    final clients = appMode.isDemo
        ? const [
            SaleClientOption(
              id: '201',
              name: 'Mercado Central',
              code: 'CLI-201',
              city: 'São Paulo - SP',
            ),
            SaleClientOption(
              id: '202',
              name: 'Padaria Estrela',
              code: 'CLI-202',
              city: 'Campinas - SP',
            ),
          ]
        : const <SaleClientOption>[];

    final products = appMode.isDemo ? seed.products : seed.products;

    return SalesState(
      clients: clients,
      products: products,
      cartItems: const {},
    );
  }

  void selectClient(SaleClientOption client) {
    state = state.copyWith(selectedClient: client);
  }

  void addProduct(SaleProductOption product) {
    final current = state.cartItems[product.id];
    final nextItems = Map<String, SaleCartItem>.from(state.cartItems);

    nextItems[product.id] = current == null
        ? SaleCartItem(
            productId: product.id,
            name: product.name,
            sku: product.sku,
            quantity: 1,
            unitPrice: product.price,
          )
        : current.copyWith(quantity: current.quantity + 1);

    state = state.copyWith(cartItems: nextItems);
  }

  void incrementQuantity(String productId) {
    final current = state.cartItems[productId];
    if (current == null) {
      return;
    }

    state = state.copyWith(
      cartItems: {
        ...state.cartItems,
        productId: current.copyWith(quantity: current.quantity + 1),
      },
    );
  }

  void decrementQuantity(String productId) {
    final current = state.cartItems[productId];
    if (current == null || current.quantity <= 1) {
      return;
    }

    state = state.copyWith(
      cartItems: {
        ...state.cartItems,
        productId: current.copyWith(quantity: current.quantity - 1),
      },
    );
  }

  void removeItem(String productId) {
    final nextItems = Map<String, SaleCartItem>.from(state.cartItems)
      ..remove(productId);
    state = state.copyWith(cartItems: nextItems);
  }

  Future<String> registerSale() async {
    final client = state.selectedClient;
    if (client == null || state.cartItems.isEmpty) {
      throw StateError(
        'Uma venda local exige cliente selecionado e ao menos um item.',
      );
    }

    final shellProfile = ref.read(shellProfileProvider);
    final useCase = ref.read(registerSaleUseCaseProvider);
    if (useCase != null) {
      final draft = SaleDraft(
        clientId: client.id,
        clientName: client.name,
        items: [
          for (final item in state.cartItems.values)
            SaleDraftItem(
              productId: item.productId,
              productName: item.name,
              productSku: item.sku,
              quantity: item.quantity,
              historicalUnitPrice: item.unitPrice,
            ),
        ],
        soldAt: ref.read(salesClockProvider)(),
        timezone: DateTime.now().timeZoneName,
      );

      final access = SaleAccess(
        hasSalesFeature: shellProfile.features.contains('sales'),
        canCreateSales: shellProfile.permissions['sales_create'] == true,
      );

      final localSaleId = await useCase.call(draft: draft, access: access);

      final engine = ref.read(contextSyncEngineProvider);
      if (engine != null) {
        unawaited(engine.sync(trigger: SyncTrigger.manual));
      }

      state = state.copyWith(cartItems: const {}, clearSelectedClient: true);
      return localSaleId;
    }

    final pendingController = ref.read(pendingSalesProvider.notifier);
    final saleId = pendingController.enqueueSale(
      client: client,
      cartItems: state.cartItems,
    );
    state = state.copyWith(cartItems: const {}, clearSelectedClient: true);
    return saleId;
  }
}
