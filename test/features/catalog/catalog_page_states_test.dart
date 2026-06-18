import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/catalog/catalog_providers.dart';
import 'package:gestor_de_estoque/features/catalog/domain/entities/catalog_product.dart';
import 'package:gestor_de_estoque/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';
import 'package:gestor_de_estoque/features/catalog/presentation/pages/catalog_page.dart';

void main() {
  testWidgets('mostra restrição específica quando feature está desativada', (
    tester,
  ) async {
    await _pumpCatalog(
      tester,
      const CatalogLoadResult.restricted(
        message: 'Feature indisponível',
        kind: CatalogRestrictionKind.featureDisabled,
        categories: ['Todos'],
      ),
    );

    expect(
      find.text('Catálogo indisponível para este tenant'),
      findsOneWidget,
    );
    expect(find.text('Feature indisponível'), findsOneWidget);
  });

  testWidgets('mostra falha acionável quando não existe cache', (tester) async {
    await _pumpCatalog(
      tester,
      const CatalogLoadResult.failure(
        message: 'Servidor indisponível',
        items: [],
        categories: ['Todos'],
      ),
    );

    expect(find.text('Falha ao consultar o catálogo'), findsOneWidget);
    expect(find.text('Servidor indisponível'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });

  testWidgets('mantém produto visível e mostra banner offline', (tester) async {
    await _pumpCatalog(
      tester,
      const CatalogLoadResult.offline(
        message: 'Sem conexão',
        items: [_product],
        categories: ['Todos'],
      ),
    );

    expect(find.text('Sem conexão'), findsOneWidget);
    expect(find.text('Produto local'), findsOneWidget);
  });

  testWidgets('mostra vazio para filtro sem resultado', (tester) async {
    await _pumpCatalog(
      tester,
      const CatalogLoadResult.empty(
        message: 'Nenhum item corresponde ao filtro',
        categories: ['Todos'],
      ),
    );

    expect(find.text('Nenhum produto encontrado'), findsOneWidget);
    expect(find.text('Nenhum item corresponde ao filtro'), findsOneWidget);
  });
}

Future<void> _pumpCatalog(
  WidgetTester tester,
  CatalogLoadResult result,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(
          _StaticCatalogRepository(result),
        ),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const CatalogPage()),
    ),
  );
  await tester.pumpAndSettle();
}

class _StaticCatalogRepository implements CatalogRepository {
  const _StaticCatalogRepository(this.result);

  final CatalogLoadResult result;

  @override
  Future<CatalogLoadResult> load(CatalogQuery query) async => result;
}

const _product = CatalogProduct(
  id: 'local',
  name: 'Produto local',
  sku: 'LOCAL-1',
  brand: 'Arara',
  stockQuantity: 2,
  stockStatus: CatalogStockStatus.low,
  isAvailableForSale: true,
  updatedAtLabel: 'Ontem',
);
