import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../shared/formatters/app_date_formatter.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/entities/catalog_read_access.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/repositories/reactive_catalog_repository.dart';
import '../../domain/value_objects/catalog_query.dart';

class DriftProductRepository implements ReactiveCatalogRepository {
  DriftProductRepository(this.database, this.access);

  final AppDatabase database;
  final CatalogReadAccess access;

  @override
  Future<CatalogLoadResult> load(CatalogQuery query) => watch(query).first;

  @override
  Stream<CatalogLoadResult> watch(CatalogQuery query) {
    if (!access.featureEnabled || !access.canViewProducts) {
      return Stream.value(CatalogLoadResult.restricted(
        message: 'O catálogo não está disponível para este acesso.',
        kind: access.featureEnabled
            ? CatalogRestrictionKind.permission
            : CatalogRestrictionKind.featureDisabled,
        categories: const ['Todos'],
      ));
    }
    // Uma consulta observável fornece produtos/categorias no mesmo snapshot.
    return database.customSelect(
      '''SELECT p.*, c.name AS category_name FROM products p
         LEFT JOIN categories c ON c.id = p.category_id
         ORDER BY p.name COLLATE NOCASE, p.id''',
      readsFrom: {database.productsTable, database.categoriesTable},
    ).watch().map((rows) {
      final products = rows.map(_mapProduct).toList();
      final names = products.map((p) => p.categoryName).whereType<String>().toSet().toList()..sort();
      final categories = ['Todos', ...names.where((name) => name != 'Todos')];
      final search = query.search.trim().toLowerCase();
      final items = products.where((product) {
        return (search.isEmpty ||
                product.name.toLowerCase().contains(search) ||
                product.sku.toLowerCase().contains(search)) &&
            (query.category == null ||
                query.category == 'Todos' ||
                product.categoryName == query.category);
      }).toList();
      return items.isEmpty
          ? CatalogLoadResult.empty(
              message: 'Nenhum produto disponível para estes filtros no dispositivo.',
              categories: categories,
            )
          : CatalogLoadResult.ready(items: items, categories: categories);
    });
  }

  CatalogProduct _mapProduct(QueryRow row) => CatalogProduct(
    id: row.read<String>('id'),
    name: row.read<String>('name'),
    sku: row.read<String>('sku'),
    brand: row.read<String>('brand'),
    price: access.canViewFinancial ? row.readNullable<double>('price') : null,
    stockQuantity: row.read<int>('stock_quantity'),
    stockStatus: CatalogStockStatus.values.byName(switch (row.read<String>('stock_status')) {
      'available' => 'available',
      'low' => 'low',
      'out' => 'out',
      _ => throw const FormatException('Estado local inválido.'),
    }),
    isAvailableForSale: row.read<bool>('is_available_for_sale'),
    updatedAtLabel: AppDateFormatter.short(row.read<DateTime>('updated_at').toLocal()),
    imageUrl: row.readNullable<String>('image_url'),
    categoryName: row.readNullable<String>('category_name'),
  );
}
