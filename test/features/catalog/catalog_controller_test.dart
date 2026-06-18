import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/catalog/catalog_providers.dart';
import 'package:gestor_de_estoque/features/catalog/domain/entities/catalog_product.dart';
import 'package:gestor_de_estoque/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';
import 'package:gestor_de_estoque/features/catalog/presentation/controllers/catalog_controller.dart';
import 'package:gestor_de_estoque/shared/ui_states/view_status.dart';

void main() {
  test('mapeia resposta offline preservando itens locais e mensagem', () async {
    final repository = _QueuedCatalogRepository();
    final container = _createContainer(repository);
    final controller = container.read(catalogControllerProvider.notifier);

    await _waitForCalls(repository, 1);
    repository.completeNext(
      CatalogLoadResult.offline(
        message: 'Sem conexão',
        items: const [_product],
        categories: const ['Todos'],
      ),
    );
    await _flush();

    final state = container.read(catalogControllerProvider);
    expect(state.status, ViewStatus.offline);
    expect(state.items, const [_product]);
    expect(state.message, 'Sem conexão');
    expect(controller, isNotNull);
    expect(() => state.items.clear(), throwsUnsupportedError);
    expect(() => state.categories.clear(), throwsUnsupportedError);
  });

  test('mapeia restrição de feature sem perder sua causa', () async {
    final repository = _QueuedCatalogRepository();
    final container = _createContainer(repository);

    await _waitForCalls(repository, 1);
    repository.completeNext(
      const CatalogLoadResult.restricted(
        message: 'Catálogo desativado',
        kind: CatalogRestrictionKind.featureDisabled,
        categories: ['Todos'],
      ),
    );
    await _flush();

    final state = container.read(catalogControllerProvider);
    expect(state.status, ViewStatus.restricted);
    expect(state.restrictionKind, CatalogRestrictionKind.featureDisabled);
    expect(state.items, isEmpty);
  });

  test('busca mais nova vence resposta antiga que chega atrasada', () async {
    final repository = _QueuedCatalogRepository();
    final container = _createContainer(repository);
    final controller = container.read(catalogControllerProvider.notifier);

    await _waitForCalls(repository, 1);
    repository.completeNext(
      const CatalogLoadResult.ready(items: [_product], categories: ['Todos']),
    );
    await _flush();

    final firstSearch = controller.updateSearch('primeira');
    final secondSearch = controller.updateSearch('segunda');
    await _waitForCalls(repository, 3);
    expect(
      container.read(catalogControllerProvider).status,
      ViewStatus.refreshing,
    );

    repository.completeAt(
      2,
      const CatalogLoadResult.ready(
        items: [_newestProduct],
        categories: ['Todos'],
      ),
    );
    await secondSearch;

    repository.completeAt(
      1,
      const CatalogLoadResult.ready(
        items: [_staleProduct],
        categories: ['Todos'],
      ),
    );
    await firstSearch;

    final state = container.read(catalogControllerProvider);
    expect(state.query.search, 'segunda');
    expect(state.items.single.id, _newestProduct.id);
  });

  test('selecionar Todos limpa o filtro de categoria', () async {
    final repository = _QueuedCatalogRepository();
    final container = _createContainer(repository);
    final controller = container.read(catalogControllerProvider.notifier);

    await _waitForCalls(repository, 1);
    repository.completeNext(
      const CatalogLoadResult.ready(
        items: [_product],
        categories: ['Todos', 'Proteção'],
      ),
    );
    await _flush();

    final filtered = controller.updateCategory('Proteção');
    await _waitForCalls(repository, 2);
    expect(repository.queries[1].category, 'Proteção');
    repository.completeAt(
      1,
      const CatalogLoadResult.ready(
        items: [_product],
        categories: ['Todos', 'Proteção'],
      ),
    );
    await filtered;

    final cleared = controller.updateCategory('Todos');
    await _waitForCalls(repository, 3);
    expect(repository.queries[2].category, isNull);
    repository.completeAt(
      2,
      const CatalogLoadResult.ready(
        items: [_product],
        categories: ['Todos', 'Proteção'],
      ),
    );
    await cleared;

    expect(container.read(catalogControllerProvider).query.category, isNull);
  });

  test('converte exceção inesperada em falha sem descartar cache', () async {
    final repository = _QueuedCatalogRepository();
    final container = _createContainer(repository);
    final controller = container.read(catalogControllerProvider.notifier);

    await _waitForCalls(repository, 1);
    repository.completeNext(
      const CatalogLoadResult.ready(
        items: [_product],
        categories: ['Todos'],
      ),
    );
    await _flush();

    final refresh = controller.refresh();
    await _waitForCalls(repository, 2);
    repository.completeErrorAt(1, StateError('falha bruta'));
    await refresh;

    final state = container.read(catalogControllerProvider);
    expect(state.status, ViewStatus.failure);
    expect(state.items, const [_product]);
    expect(state.message, contains('catálogo'));
  });
}

ProviderContainer _createContainer(_QueuedCatalogRepository repository) {
  final container = ProviderContainer(
    overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  container.read(catalogControllerProvider);
  return container;
}

Future<void> _waitForCalls(
  _QueuedCatalogRepository repository,
  int count,
) async {
  while (repository.queries.length < count) {
    await _flush();
  }
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

class _QueuedCatalogRepository implements CatalogRepository {
  final queries = <CatalogQuery>[];
  final _completers = <Completer<CatalogLoadResult>>[];

  @override
  Future<CatalogLoadResult> load(CatalogQuery query) {
    queries.add(query);
    final completer = Completer<CatalogLoadResult>();
    _completers.add(completer);
    return completer.future;
  }

  void completeNext(CatalogLoadResult result) {
    final index = _completers.indexWhere((item) => !item.isCompleted);
    completeAt(index, result);
  }

  void completeAt(int index, CatalogLoadResult result) {
    _completers[index].complete(result);
  }

  void completeErrorAt(int index, Object error) {
    _completers[index].completeError(error);
  }
}

const _product = CatalogProduct(
  id: 'base',
  name: 'Produto base',
  sku: 'BASE',
  brand: 'Arara',
  stockQuantity: 1,
  stockStatus: CatalogStockStatus.available,
  isAvailableForSale: true,
  updatedAtLabel: 'Agora',
);

const _staleProduct = CatalogProduct(
  id: 'stale',
  name: 'Resposta antiga',
  sku: 'OLD',
  brand: 'Arara',
  stockQuantity: 1,
  stockStatus: CatalogStockStatus.available,
  isAvailableForSale: true,
  updatedAtLabel: 'Agora',
);

const _newestProduct = CatalogProduct(
  id: 'newest',
  name: 'Resposta nova',
  sku: 'NEW',
  brand: 'Arara',
  stockQuantity: 1,
  stockStatus: CatalogStockStatus.available,
  isAvailableForSale: true,
  updatedAtLabel: 'Agora',
);
