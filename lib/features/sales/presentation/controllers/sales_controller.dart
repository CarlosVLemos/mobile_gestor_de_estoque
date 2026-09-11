import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/composition/local_context_composition.dart';
import '../../../../app/shell/shell_profile.dart';
import '../../../../core/sync/sync_state.dart';
import '../../sales_providers.dart';
import '../../domain/entities/sale_reference_data.dart';
import '../../domain/entities/sale_sync.dart';
import '../state/sales_state.dart';

final salesControllerProvider = NotifierProvider<SalesController, SalesState>(
  SalesController.new,
);

class SalesController extends Notifier<SalesState> {
  @override
  SalesState build() {
    ref.listen(salesDraftSeedProvider, (_, next) {
      next.when(
        data: _replaceReferences,
        error: (error, _) => state = state.copyWith(
          referenceFailure: 'Dados locais de clientes/produtos indisponíveis.',
        ),
        loading: () {},
      );
    });
    final initial = ref.read(salesDraftSeedProvider);
    return initial.when(
      data: (seed) => SalesState(
        clients: seed.clients,
        products: seed.products,
        cartItems: const {},
      ),
      error: (_, _) => SalesState(
        clients: const [],
        products: const [],
        cartItems: const {},
        referenceFailure: 'Dados locais de clientes/produtos indisponíveis.',
      ),
      loading: () => SalesState(
        clients: const [],
        products: const [],
        cartItems: const {},
      ),
    );
  }

  void _replaceReferences(SalesDraftSeed seed) {
    state = state.copyWith(
      clients: seed.clients,
      products: seed.products,
      clearReferenceFailure: true,
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

    final timezone = ref.read(salesTimeZoneProvider);
    if (timezone == null) {
      throw const SaleRegistrationException(
        'iana_timezone_unavailable',
        'Configure APP_TIMEZONE com uma timezone IANA válida.',
      );
    }
    final useCase = ref.read(registerSaleUseCaseProvider);
    if (useCase == null) {
      throw StateError('Infraestrutura persistente de vendas indisponível.');
    }
    final profile = ref.read(shellProfileProvider);
    final saleId = await useCase.call(
      access: SaleAccess(
        hasSalesFeature: profile.features.contains('sales'),
        canCreateSales: profile.permissions['sales_create'] == true,
      ),
      draft: SaleDraft(
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
        timezone: timezone,
      ),
    );
    state = state.copyWith(cartItems: const {}, clearSelectedClient: true);
    final engine = ref.read(contextSyncEngineProvider);
    if (engine != null) unawaited(engine.sync(trigger: SyncTrigger.manual));
    return saleId;
  }

  Future<void> acceptProposal(String saleId, int proposalRevision) async {
    final processor = ref.read(contextOutboxProcessorProvider);
    final engine = ref.read(contextSyncEngineProvider);
    if (processor == null || engine == null) {
      throw StateError('Sincronização de vendas indisponível.');
    }
    await processor.accept(saleId, expectedProposalRevision: proposalRevision);
    unawaited(engine.sync(trigger: SyncTrigger.manual));
  }
}
