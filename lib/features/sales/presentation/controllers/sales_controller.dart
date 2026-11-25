import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/composition/local_context_composition.dart';
import '../../../../app/shell/shell_profile.dart';
import '../../../../core/sync/sync_state.dart';
import '../../sales_providers.dart';
import '../../domain/entities/sale_reference_data.dart';
import '../../domain/entities/sale_sync.dart';
import '../state/sales_state.dart';
import '../state/sale_submission_gate.dart';

final salesControllerProvider = NotifierProvider<SalesController, SalesState>(
  SalesController.new,
);

class SalesController extends Notifier<SalesState> {
  int _generation = 0;

  int get revision => _generation;
  bool isCurrentRevision(int value) => ref.mounted && _generation == value;

  @override
  SalesState build() {
    _generation++;
    final context = ref.watch(activeSyncContextProvider);
    final gate = ref.read(saleSubmissionGateProvider);
    void refreshSubmission() {
      if (!ref.mounted) return;
      state = state.copyWith(
        submissionStatus: gate.attempt(context)?.status ?? SaleSubmissionStatus.idle,
      );
    }
    gate.addListener(refreshSubmission);
    ref.onDispose(() => gate.removeListener(refreshSubmission));
    final submissionStatus = gate.attempt(context)?.status ?? SaleSubmissionStatus.idle;
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
        submissionStatus: submissionStatus,
      ),
      error: (_, _) => SalesState(
        clients: const [],
        products: const [],
        cartItems: const {},
        submissionStatus: submissionStatus,
        referenceFailure: 'Dados locais de clientes/produtos indisponíveis.',
      ),
      loading: () => SalesState(
        clients: const [],
        products: const [],
        cartItems: const {},
        submissionStatus: submissionStatus,
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
    if (state.isSubmissionBlocked) return;
    state = state.copyWith(selectedClient: client);
  }

  void addProduct(SaleProductOption product) {
    if (state.isSubmissionBlocked) return;
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
    if (state.isSubmissionBlocked) return;
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
    if (state.isSubmissionBlocked) return;
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
    if (state.isSubmissionBlocked) return;
    final nextItems = Map<String, SaleCartItem>.from(state.cartItems)
      ..remove(productId);
    state = state.copyWith(cartItems: nextItems);
  }

  Future<String> registerSale() async {
    final generation = _generation;
    final context = ref.read(activeSyncContextProvider);
    final gate = ref.read(saleSubmissionGateProvider);
    if (gate.attempt(context) != null) {
      throw StateError('Já existe uma venda em processamento.');
    }
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
    final engine = ref.read(contextSyncEngineProvider);
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
        timezone: timezone,
    );
    final attemptId = useCase.newAttemptId();
    if (!gate.begin(context, attemptId)) {
      throw StateError('Já existe uma venda em processamento.');
    }
    String saleId;
    try {
      saleId = await useCase.call(
      attemptId: attemptId,
      access: SaleAccess(
        hasSalesFeature: profile.features.contains('sales'),
        canCreateSales: profile.permissions['sales_create'] == true,
      ),
      draft: draft,
    );
    } catch (_) {
      final registered = await useCase.isRegistered(attemptId);
      if (registered == null) {
        gate.uncertain(context, attemptId);
        throw StateError('Não foi possível verificar o registro. Consulte o histórico antes de tentar novamente.');
      }
      if (!registered) {
        gate.finish(context, attemptId);
        rethrow;
      }
      saleId = attemptId;
    }
    if (ref.mounted && _generation == generation && ref.read(activeSyncContextProvider) == context) {
      state = state.copyWith(cartItems: const {}, clearSelectedClient: true);
      if (engine != null) {
        try {
          unawaited(engine.sync(trigger: SyncTrigger.manual).then<void>(
            (_) {},
            onError: (Object _, StackTrace __) {},
          ));
        } catch (_) {
          // Local persistence already succeeded; the outbox can sync later.
        }
      }
    }
    gate.finish(context, attemptId);
    return saleId;
  }

  Future<bool?> reconcileSubmission() async {
    final generation = _generation;
    final context = ref.read(activeSyncContextProvider);
    final gate = ref.read(saleSubmissionGateProvider);
    final attempt = gate.attempt(context);
    final useCase = ref.read(registerSaleUseCaseProvider);
    if (attempt == null ||
        attempt.status != SaleSubmissionStatus.uncertain ||
        useCase == null) return null;
    final registered = await useCase.isRegistered(attempt.id);
    if (registered == null) return null;
    if (!identical(gate.attempt(context), attempt)) return null;
    if (registered && ref.mounted && _generation == generation && ref.read(activeSyncContextProvider) == context) {
      state = state.copyWith(cartItems: const {}, clearSelectedClient: true);
    }
    gate.finish(context, attempt.id);
    return registered;
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
