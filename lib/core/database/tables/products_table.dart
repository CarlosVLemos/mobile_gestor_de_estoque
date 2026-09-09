import 'package:drift/drift.dart';

import 'categories_table.dart';

@DataClassName('StoredProduct')
class ProductsTable extends Table {
  @override
  String get tableName => 'products';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get sku => text()();
  TextColumn get brand => text().nullable()();
  RealColumn get price => real().nullable()();
  IntColumn get stockQuantity => integer()();
  TextColumn get stockStatus => text()();
  BoolColumn get isAvailableForSale => boolean()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get categoryId => text().nullable().references(
    CategoriesTable,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get remoteUpdatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
