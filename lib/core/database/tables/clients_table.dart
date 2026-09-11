import 'package:drift/drift.dart';

@DataClassName('StoredClient')
class ClientsTable extends Table {
  @override
  String get tableName => 'clients';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
