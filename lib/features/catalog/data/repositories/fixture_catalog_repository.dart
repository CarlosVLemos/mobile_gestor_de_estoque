import '../../../../core/config/fixture_access_profile.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/value_objects/catalog_query.dart';
import '../local/catalog_fixture.dart';

class FixtureCatalogRepository implements CatalogRepository {
  const FixtureCatalogRepository();

  @override
  Future<CatalogLoadResult> load(CatalogQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));

    final categories = const ['Todos', 'Proteção', 'Elétrica', 'Acessórios'];

    if (!appFixtureAccessProfile.hasCatalogFeature) {
      return CatalogLoadResult.restricted(
        message:
            'O módulo de catálogo está desativado para este tenant neste momento.',
        kind: CatalogRestrictionKind.featureDisabled,
        categories: categories,
      );
    }

    if (!appFixtureAccessProfile.canViewProducts) {
      return CatalogLoadResult.restricted(
        message:
            'Seu perfil não tem permissão para consultar o catálogo no app.',
        kind: CatalogRestrictionKind.permission,
        categories: categories,
      );
    }

    if (query.search.trim().length > 40) {
      return CatalogLoadResult.invalidFilter(
        message: 'Refine a busca: o termo informado está grande demais.',
        categories: categories,
      );
    }

    final normalizedSearch = query.search.trim().toLowerCase();
    final selectedCategory = query.category == null || query.category == 'Todos'
        ? null
        : query.category;

    final items = buildCatalogFixture().where((product) {
      final matchesSearch =
          normalizedSearch.isEmpty ||
          product.name.toLowerCase().contains(normalizedSearch) ||
          product.sku.toLowerCase().contains(normalizedSearch);
      final matchesCategory =
          selectedCategory == null || product.categoryName == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    if (items.isEmpty) {
      return CatalogLoadResult.empty(
        message: normalizedSearch.isNotEmpty || selectedCategory != null
            ? 'Nenhum produto corresponde aos filtros informados.'
            : 'Ainda não há produtos disponíveis neste recorte.',
        categories: categories,
      );
    }

    return CatalogLoadResult.ready(items: items, categories: categories);
  }
}
