import 'package:drift/drift.dart';

@DataClassName('StoredLocalSale')
class LocalSalesTable extends Table {
  @override
  String get tableName => 'local_sales';

  TextColumn get id => text()();
  TextColumn get clientRequestId => text().unique()();
  TextColumn get clientId => text()();
  TextColumn get clientName => text()();
  DateTimeColumn get soldAt => dateTime()();
  TextColumn get timezone => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
