import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/ui_states/view_status.dart';
import '../../catalog_providers.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../state/catalog_state.dart';

final catalogControllerProvider =
    NotifierProvider<CatalogController, CatalogState>(CatalogController.new);

class CatalogController extends Notifier<CatalogState> {
  var _initialized = false;

  @override
  CatalogState build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(load);
    }
    return const CatalogState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(status: ViewStatus.loading, clearMessage: true);
    final result = await ref.read(loadCatalogUseCaseProvider).call(state.query);
    _applyResult(result);
  }

  Future<void> refresh() async {
    state = state.copyWith(status: ViewStatus.refreshing, clearMessage: true);
    final result = await ref.read(loadCatalogUseCaseProvider).call(state.query);
    _applyResult(result);
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
  }
}
