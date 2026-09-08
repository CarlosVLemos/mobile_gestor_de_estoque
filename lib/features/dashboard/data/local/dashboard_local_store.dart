import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_overview.dart';
import 'dashboard_snapshot_codec.dart';

class DashboardLocalStore {
  DashboardLocalStore(this.database);

  final AppDatabase database;

  Future<void> replace(DashboardOverview overview) => database.transaction(() async {
    await database.delete(database.dashboardKpisTable).go();
    await database.delete(database.dashboardStockAlertsTable).go();
    await database.batch((batch) {
      batch.insertAll(database.dashboardKpisTable, [
        for (var i = 0; i < overview.kpis.length; i++)
          DashboardKpisTableCompanion.insert(
            position: i,
            label: overview.kpis[i].label,
            value: Value(overview.kpis[i].value),
            subtitle: Value(overview.kpis[i].subtitle),
            isCurrency: overview.kpis[i].isCurrency,
            isRestricted: overview.kpis[i].isRestricted,
            isHighlighted: overview.kpis[i].isHighlighted,
          ),
      ]);
      batch.insertAll(database.dashboardStockAlertsTable, [
        for (var i = 0; i < overview.lowStockAlerts.length; i++)
          DashboardStockAlertsTableCompanion.insert(
            position: i,
            productName: overview.lowStockAlerts[i].productName,
            stockLabel: overview.lowStockAlerts[i].stockLabel,
            toneLabel: overview.lowStockAlerts[i].toneLabel,
          ),
      ]);
      batch.insertAllOnConflictUpdate(database.dashboardSnapshotsTable, [
        DashboardSnapshotsTableCompanion.insert(
          id: 'current',
          details: DashboardSnapshotCodec.encodeDetails(overview),
        ),
      ]);
    });
  });

  Stream<DashboardOverview?> watch() => database.customSelect(
    'SELECT id FROM dashboard_snapshots',
    readsFrom: {
      database.dashboardKpisTable,
      database.dashboardStockAlertsTable,
      database.dashboardSnapshotsTable,
    },
  ).watch().asyncMap((_) => read());

  Future<DashboardOverview?> read() => database.transaction(() async {
    final snapshot = await (database.select(database.dashboardSnapshotsTable)
          ..where((row) => row.id.equals('current'))).getSingleOrNull();
    if (snapshot == null) return null;
    final kpis = await (database.select(database.dashboardKpisTable)
          ..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    final alerts = await (database.select(database.dashboardStockAlertsTable)
          ..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    return DashboardSnapshotCodec.decodeDetails(
      snapshot.details,
      kpis.map((row) => DashboardKpi(
        label: row.label,
        value: row.value,
        subtitle: row.subtitle,
        isCurrency: row.isCurrency,
        isRestricted: row.isRestricted,
        isHighlighted: row.isHighlighted,
      )).toList(),
      alerts.map((row) => DashboardStockAlert(
        productName: row.productName,
        stockLabel: row.stockLabel,
        toneLabel: row.toneLabel,
      )).toList(),
    );
  });
}
