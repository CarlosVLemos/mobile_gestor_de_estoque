import 'package:drift/drift.dart';

import 'local_sales_table.dart';

@DataClassName('StoredLocalSaleItem')
class LocalSaleItemsTable extends Table {
  @override
  String get tableName => 'local_sale_items';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get saleId => text().references(
    LocalSalesTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  TextColumn get productSku => text().nullable()();
  IntColumn get quantity => integer()();
  RealColumn get historicalUnitPrice => real().nullable()();
}
