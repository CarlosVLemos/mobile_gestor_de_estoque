import 'package:drift/drift.dart';

@DataClassName('StoredDashboardSnapshot')
class DashboardSnapshotsTable extends Table {
  @override
  String get tableName => 'dashboard_snapshots';

  TextColumn get scopeKey => text()();
  TextColumn get period => text()();
  TextColumn get groupBy => text()();
  IntColumn get page => integer()();
  TextColumn get revision => text()();
  DateTimeColumn get generatedAt => dateTime()();
  TextColumn get referenceDate => text()();
  TextColumn get webDashboardUrl => text()();
  BoolColumn get canViewFinancial => boolean()();

  /// Serialized storage detail. JSON must not cross the data-layer boundary.
  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {scopeKey};
}
