import 'package:drift/drift.dart';

@DataClassName('StoredCategory')
class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
