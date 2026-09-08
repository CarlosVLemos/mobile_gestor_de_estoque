import 'package:drift/drift.dart';

@DataClassName('StoredDashboardKpi')
class DashboardKpisTable extends Table {
  @override
  String get tableName => 'dashboard_kpis';

  IntColumn get position => integer()();
  TextColumn get label => text()();
  TextColumn get value => text().nullable()();
  TextColumn get subtitle => text().nullable()();
  BoolColumn get isCurrency => boolean()();
  BoolColumn get isRestricted => boolean()();
  BoolColumn get isHighlighted => boolean()();

  @override
  Set<Column> get primaryKey => {position};
}

@DataClassName('StoredDashboardStockAlert')
class DashboardStockAlertsTable extends Table {
  @override
  String get tableName => 'dashboard_stock_alerts';

  IntColumn get position => integer()();
  TextColumn get productName => text()();
  TextColumn get stockLabel => text()();
  TextColumn get toneLabel => text()();

  @override
  Set<Column> get primaryKey => {position};
}

@DataClassName('StoredDashboardSnapshot')
class DashboardSnapshotsTable extends Table {
  @override
  String get tableName => 'dashboard_snapshots';

  TextColumn get id => text()();
  // Formato local versionado; não é o payload HTTP.
  TextColumn get details => text()();

  @override
  Set<Column> get primaryKey => {id};
}
