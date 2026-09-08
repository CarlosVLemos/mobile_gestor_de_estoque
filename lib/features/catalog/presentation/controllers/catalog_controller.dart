import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/ui_states/view_status.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/sync/sync_state.dart';
import '../../../../core/sync/sync_exception.dart';
import '../../catalog_providers.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../state/catalog_state.dart';

final catalogControllerProvider =
    NotifierProvider.autoDispose<CatalogController, CatalogState>(CatalogController.new);

class CatalogController extends Notifier<CatalogState> {
  var _requestSequence = 0;
  ProviderSubscription<AsyncValue<CatalogLoadResult>>? _subscription;
  Completer<void>? _pending;
  CatalogLoadResult? _latest;
  SyncState _sync = const SyncState();
  bool _denied = false;

  @override
  CatalogState build() {
    ref.onDispose(_stop);
    ref.listen(syncStateProvider, (_, next) {
      final value = next.asData?.value;
      if (value == null) return;
      _sync = value;
      if (value.accessDenied || value.failureKind == SyncFailureKind.unauthorized ||
          value.failureKind == SyncFailureKind.forbidden) {
        _denied = true;
      } else if (value.completedCollections.contains('products')) {
        _denied = false;
      }
      if (_latest != null) _applyResult(_latest!);
    }, fireImmediately: true);
    Future<void>.microtask(() async {
      if (ref.mounted) await load();
    });
    return CatalogState.initial();
  }

  void _stop() {
    _requestSequence++;
    _subscription?.close();
    _subscription = null;
    final pending = _pending;
    if (pending != null && !pending.isCompleted) pending.complete();
  }

  Future<void> load() {
    _stop();
    final requestId = _requestSequence;
    final pending = _pending = Completer<void>();
    final provider = catalogProductsStreamProvider(state.query);
    state = state.copyWith(
      status: state.items.isEmpty ? ViewStatus.loading : ViewStatus.refreshing,
      clearMessage: true,
    );
    ref.invalidate(provider);
    _subscription = ref.listen(provider, (_, next) {
      if (!ref.mounted || requestId != _requestSequence) return;
      final result = next.asData?.value;
      if (result != null) {
        _latest = result;
        _applyResult(result);
      } else if (next.hasError) {
        _applyUnexpectedFailure();
      } else {
        return;
      }
      if (!pending.isCompleted) pending.complete();
    }, fireImmediately: true);
    return pending.future;
  }

  Future<void> refresh() async {
    state = state.copyWith(status: ViewStatus.refreshing, clearMessage: true);
    await ref.read(synchronizeUseCaseProvider).call();
    if (ref.mounted) await load();
  }

  Future<void> updateSearch(String search) async {
    state = state.copyWith(query: state.query.copyWith(search: search));
    await load();
  }

  Future<void> updateCategory(String category) async {
    state = state.copyWith(
      query: state.query.copyWith(
        category: category == 'Todos' ? null : category,
        clearCategory: category == 'Todos',
      ),
    );
    await load();
  }

  void _applyResult(CatalogLoadResult result) {
    switch (result.status) {
      case CatalogLoadStatus.ready:
        state = state.copyWith(
          status: ViewStatus.ready,
          items: result.items,
          categories: result.categories,
          clearMessage: true,
          clearRestrictionKind: true,
        );
      case CatalogLoadStatus.empty:
        state = state.copyWith(
          status: ViewStatus.empty,
          items: const [],
          categories: result.categories,
          message: result.message,
          clearRestrictionKind: true,
        );
      case CatalogLoadStatus.restricted:
        state = state.copyWith(
          status: ViewStatus.restricted,
          items: const [],
          categories: result.categories,
          message: result.message,
          restrictionKind: result.restrictionKind,
        );
      case CatalogLoadStatus.offline:
        state = state.copyWith(
          status: ViewStatus.offline,
          items: result.items,
          categories: result.categories,
          message: result.message,
          clearRestrictionKind: true,
        );
      case CatalogLoadStatus.failure:
      case CatalogLoadStatus.rateLimited:
      case CatalogLoadStatus.invalidFilter:
        state = state.copyWith(
          status: result.status == CatalogLoadStatus.invalidFilter
              ? ViewStatus.empty
              : ViewStatus.failure,
          items: result.items,
          categories: result.categories,
          message: result.message,
          clearRestrictionKind: true,
        );
    }
    _applySyncStatus();
  }

  void _applySyncStatus() {
    if (_denied) {
      state = state.copyWith(
        status: ViewStatus.restricted,
        items: const [],
        categories: const ['Todos'],
        restrictionKind: CatalogRestrictionKind.permission,
        message: 'O acesso foi negado. Valide sua sessão e permissões.',
        clearSyncMessage: true,
        syncing: false,
      );
      return;
    }
    final failed = _sync.status == SyncStatus.failed;
    final message = _sync.failureKind == SyncFailureKind.offline
        ? 'Sem conexão. Exibindo os dados disponíveis no dispositivo.'
        : 'A sincronização falhou. Os dados locais foram mantidos.';
    state = state.copyWith(
      status: failed && state.items.isEmpty && state.status != ViewStatus.restricted
          ? ViewStatus.failure : state.status,
      syncMessage: failed ? message : null,
      clearSyncMessage: !failed,
      syncing: _sync.status == SyncStatus.syncing,
    );
  }

  void _applyUnexpectedFailure() {
    state = state.copyWith(
      status: ViewStatus.failure,
      message: 'Não foi possível carregar o catálogo neste momento.',
      clearRestrictionKind: true,
    );
  }
}
