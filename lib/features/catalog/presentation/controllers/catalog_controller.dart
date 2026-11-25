import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/ui_states/view_status.dart';
import '../../../../app/local_context_lifecycle.dart';
import '../../../../core/sync/sync_state.dart';
import '../../../../core/sync/sync_exception.dart';
import '../../catalog_providers.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/value_objects/catalog_query.dart';
import '../state/catalog_state.dart';

final catalogControllerProvider =
    NotifierProvider<CatalogController, CatalogState>(CatalogController.new);

class CatalogController extends Notifier<CatalogState> {
  var _initialized = false;
  var _requestSequence = 0;
  var _queryRevision = 0;
  var _watchRevision = 0;
  StreamSubscription<CatalogLoadResult>? _localSubscription;

  @override
  CatalogState build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(() async {
        if (!ref.mounted) return;
        final revision = _queryRevision;
        await _watchLocal(state.query, revision);
        if (ref.mounted && revision == _queryRevision) await load();
      });
      ref.onDispose(() {
        _queryRevision++;
        _watchRevision++;
        final subscription = _localSubscription;
        _localSubscription = null;
        if (subscription != null) unawaited(subscription.cancel());
      });
    }
    return CatalogState.initial();
  }

  Future<void> load() async {
    final requestId = ++_requestSequence;
    final queryRevision = _queryRevision;
    final query = state.query;
    state = state.copyWith(
      status: state.items.isEmpty ? ViewStatus.loading : ViewStatus.refreshing,
      clearMessage: true,
    );
    try {
      final result = await ref.read(loadCatalogUseCaseProvider).call(query);
      if (!ref.mounted || requestId != _requestSequence || queryRevision != _queryRevision) {
        return;
      }
      _applyResult(result);
    } on Object {
      if (!ref.mounted || requestId != _requestSequence || queryRevision != _queryRevision) {
        return;
      }
      _applyUnexpectedFailure();
    }
  }

  Future<void> refresh() async {
    final requestId = ++_requestSequence;
    final queryRevision = _queryRevision;
    final query = state.query;
    state = state.copyWith(status: ViewStatus.refreshing, clearMessage: true);
    try {
      final engine = ref.read(contextSyncEngineProvider);
      final outcome = engine == null
          ? SyncOutcome.succeeded
          : await engine.sync(trigger: SyncTrigger.manual);
      if (!ref.mounted || requestId != _requestSequence || queryRevision != _queryRevision) return;
      final loaded = await ref.read(loadCatalogUseCaseProvider).call(query);
      final result = outcome == SyncOutcome.succeeded || outcome == SyncOutcome.busy
          ? loaded
          : engine?.state.failureKind == SyncFailureKind.forbidden
          ? CatalogLoadResult.restricted(
              message: 'Seu acesso ao catálogo foi revogado.',
              kind: CatalogRestrictionKind.permission,
              categories: const ['Todos'],
            )
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
      if (!ref.mounted || requestId != _requestSequence || queryRevision != _queryRevision) {
        return;
      }
      _applyResult(result);
    } on Object {
      if (!ref.mounted || requestId != _requestSequence || queryRevision != _queryRevision) {
        return;
      }
      _applyUnexpectedFailure();
    }
  }

  Future<void> updateSearch(String search) async {
    final revision = ++_queryRevision;
    _requestSequence++;
    state = state.copyWith(query: state.query.copyWith(search: search));
    await _watchLocal(state.query, revision);
    if (ref.mounted && revision == _queryRevision) await load();
  }

  Future<void> updateCategory(String category) async {
    final revision = ++_queryRevision;
    _requestSequence++;
    state = state.copyWith(
      query: state.query.copyWith(
        category: category == 'Todos' ? null : category,
        clearCategory: category == 'Todos',
      ),
    );
    await _watchLocal(state.query, revision);
    if (ref.mounted && revision == _queryRevision) await load();
  }

  Future<void> _watchLocal(CatalogQuery query, int queryRevision) async {
    final watchRevision = ++_watchRevision;
    final previous = _localSubscription;
    _localSubscription = null;
    if (previous != null) await previous.cancel();
    if (!ref.mounted || watchRevision != _watchRevision || queryRevision != _queryRevision) return;
    final repository = ref.read(catalogRepositoryProvider);
    if (repository is! ReactiveCatalogRepository) return;
    _localSubscription = repository.watch(query).listen(
      (result) {
        if (ref.mounted && watchRevision == _watchRevision && queryRevision == _queryRevision) {
          _applyResult(result);
        }
      },
      onError: (Object _, StackTrace __) {
        if (ref.mounted && watchRevision == _watchRevision && queryRevision == _queryRevision) {
          _applyUnexpectedFailure();
        }
      },
    );
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
