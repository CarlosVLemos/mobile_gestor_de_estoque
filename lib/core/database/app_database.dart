import 'package:drift/drift.dart';

import 'tables/categories_table.dart';
import 'tables/dashboard_snapshots_table.dart';
import 'tables/products_table.dart';
import 'tables/sync_collections_table.dart';
import 'tables/sync_locks_table.dart';

part 'app_database.g.dart';

/// Minimal durable queue boundary. The delivery protocol belongs to Spec 010;
/// this table exists now so a context shutdown can preserve and inspect work
/// that has not been confirmed remotely.
class SyncOutbox extends Table {
  @override
  String get tableName => 'sync_outbox';

  TextColumn get id => text()();
  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    SyncOutbox,
    CategoriesTable,
    ProductsTable,
    DashboardSnapshotsTable,
    SyncCollectionsTable,
    SyncLocksTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from == 1 && to == 3) {
        // 008B's sync_outbox is deliberately absent from this migration: the
        // v1 table and all of its rows must remain untouched.
        await migrator.createTable(categoriesTable);
        await migrator.createTable(productsTable);
        await migrator.createTable(dashboardSnapshotsTable);
        await migrator.createTable(syncCollectionsTable);
        await migrator.createTable(syncLocksTable);
        return;
      }

      if (from == 2 && to == 3) {
        await migrator.createTable(syncLocksTable);
        return;
      }

      throw StateError('Migração de schema $from para $to não implementada.');
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<int> pendingOutboxCount() async {
    final entries =
        await (select(syncOutbox)..where(
              (entry) =>
                  entry.status.equals('pending') |
                  entry.status.equals('syncing') |
                  entry.status.equals('failed_retryable') |
                  entry.status.equals('requires_acceptance'),
            ))
            .get();
    return entries.length;
  }

  Selectable<StoredProduct> activeProducts() => select(productsTable)
    ..where((product) => product.deletedAt.isNull());

  Stream<List<StoredProduct>> watchActiveProducts() => activeProducts().watch();

  Stream<StoredDashboardSnapshot?> watchDashboardSnapshot(String scopeKey) =>
      (select(dashboardSnapshotsTable)
            ..where((snapshot) => snapshot.scopeKey.equals(scopeKey)))
          .watchSingleOrNull();

  Future<StoredSyncCollection?> readSyncCollection(String collection) =>
      (select(syncCollectionsTable)
            ..where((row) => row.collection.equals(collection)))
          .getSingleOrNull();
}
