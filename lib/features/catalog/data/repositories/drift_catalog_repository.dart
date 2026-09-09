import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../shared/formatters/app_date_formatter.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/value_objects/catalog_query.dart';

class DriftCatalogRepository implements ReactiveCatalogRepository {
  DriftCatalogRepository(
    this._database, {
    required this.hasCatalogFeature,
    required this.canViewProducts,
  });
  final AppDatabase _database;
  final bool hasCatalogFeature;
  final bool canViewProducts;

  @override
  Future<CatalogLoadResult> load(CatalogQuery query) => watch(query).first;

  @override
  Stream<CatalogLoadResult> watch(CatalogQuery query) {
    if (!hasCatalogFeature || !canViewProducts) {
      return Stream.value(
        CatalogLoadResult.restricted(
          message: 'O catálogo não está disponível para este acesso.',
          kind: hasCatalogFeature
              ? CatalogRestrictionKind.permission
              : CatalogRestrictionKind.featureDisabled,
          categories: const ['Todos'],
        ),
      );
    }
    return _database.customSelect(
      'SELECT p.*, c.name AS category_name FROM products p LEFT JOIN categories c ON c.id = p.category_id WHERE p.deleted_at IS NULL ORDER BY p.name COLLATE NOCASE, p.id',
      readsFrom: {_database.productsTable, _database.categoriesTable},
    ).watch().map((rows) {
    final products = rows.map(_product).toList(growable: false);
    final categoryNames = products.map((item) => item.categoryName).whereType<String>().toSet().toList()..sort();
    final categories = ['Todos', ...categoryNames];
    final search = query.search.trim().toLowerCase();
    final visible = products.where((item) => (search.isEmpty || item.name.toLowerCase().contains(search) || item.sku.toLowerCase().contains(search)) && (query.category == null || item.categoryName == query.category)).toList();
    return visible.isEmpty ? CatalogLoadResult.empty(message: 'Nenhum produto disponível neste dispositivo.', categories: categories) : CatalogLoadResult.ready(items: visible, categories: categories);
    });
  }

  CatalogProduct _product(QueryRow row) => CatalogProduct(
    id: row.read<String>('id'), name: row.read<String>('name'), sku: row.read<String>('sku'), brand: row.readNullable<String>('brand'), price: row.readNullable<double>('price'), stockQuantity: row.read<int>('stock_quantity'), stockStatus: CatalogStockStatus.values.byName(row.read<String>('stock_status')), isAvailableForSale: row.read<bool>('is_available_for_sale'), updatedAtLabel: row.readNullable<DateTime>('remote_updated_at') == null ? '' : AppDateFormatter.short(row.read<DateTime>('remote_updated_at').toLocal()), imageUrl: row.readNullable<String>('image_url'), categoryName: row.readNullable<String>('category_name'),
  );
}
