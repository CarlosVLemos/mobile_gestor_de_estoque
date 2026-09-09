import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/ui_states/view_status.dart';
import '../../../../app/local_context_lifecycle.dart';
import '../../../../core/sync/sync_state.dart';
import '../../catalog_providers.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../state/catalog_state.dart';

final catalogControllerProvider =
    NotifierProvider<CatalogController, CatalogState>(CatalogController.new);

class CatalogController extends Notifier<CatalogState> {
  var _initialized = false;
  var _requestSequence = 0;
  StreamSubscription<CatalogLoadResult>? _localSubscription;

  @override
  CatalogState build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(() async {
        await _watchLocal();
        await load();
      });
      ref.onDispose(() => _localSubscription?.cancel());
    }
    return CatalogState.initial();
  }

  Future<void> load() async {
    final requestId = ++_requestSequence;
    final query = state.query;
    state = state.copyWith(
      status: state.items.isEmpty ? ViewStatus.loading : ViewStatus.refreshing,
      clearMessage: true,
    );
    try {
      final result = await ref.read(loadCatalogUseCaseProvider).call(query);
      if (requestId != _requestSequence) {
        return;
      }
      _applyResult(result);
    } on Object {
      if (requestId != _requestSequence) {
        return;
      }
      _applyUnexpectedFailure();
    }
  }

  Future<void> refresh() async {
    final requestId = ++_requestSequence;
    final query = state.query;
    state = state.copyWith(status: ViewStatus.refreshing, clearMessage: true);
    try {
      final engine = ref.read(contextSyncEngineProvider);
      final outcome = engine == null
          ? SyncOutcome.succeeded
          : await engine.sync(trigger: SyncTrigger.manual);
      final loaded = await ref.read(loadCatalogUseCaseProvider).call(query);
      final result = outcome == SyncOutcome.succeeded || outcome == SyncOutcome.busy
          ? loaded
          : loaded.items.isEmpty
          ? CatalogLoadResult.failure(
              message: 'Não foi possível atualizar o catálogo.',
              items: const [],
              categories: loaded.categories,
            )
          : CatalogLoadResult.offline(
              message: 'Não foi possível atualizar o catálogo. Exibindo os dados locais.',
              items: loaded.items,
              categories: loaded.categories,
            );
      if (requestId != _requestSequence) {
        return;
      }
      _applyResult(result);
    } on Object {
      if (requestId != _requestSequence) {
        return;
      }
      _applyUnexpectedFailure();
    }
  }

  Future<void> updateSearch(String search) async {
    state = state.copyWith(query: state.query.copyWith(search: search));
    await _watchLocal();
    await load();
  }

  Future<void> updateCategory(String category) async {
    state = state.copyWith(
      query: state.query.copyWith(
        category: category == 'Todos' ? null : category,
        clearCategory: category == 'Todos',
      ),
    );
    await _watchLocal();
    await load();
  }

  Future<void> _watchLocal() async {
    await _localSubscription?.cancel();
    final repository = ref.read(catalogRepositoryProvider);
    if (repository is! ReactiveCatalogRepository) return;
    _localSubscription = repository.watch(state.query).listen(_applyResult);
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
  }

  void _applyUnexpectedFailure() {
    state = state.copyWith(
      status: ViewStatus.failure,
      message: 'Não foi possível carregar o catálogo neste momento.',
      clearRestrictionKind: true,
    );
  }
}
