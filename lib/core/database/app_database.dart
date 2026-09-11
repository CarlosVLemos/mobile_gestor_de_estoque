import 'package:drift/drift.dart';

import 'tables/categories_table.dart';
import 'tables/client_snapshot_entries_table.dart';
import 'tables/clients_table.dart';
import 'tables/dashboard_snapshots_table.dart';
import 'tables/local_sale_items_table.dart';
import 'tables/local_sales_table.dart';
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
  TextColumn get clientRequestId => text().nullable().unique()();
  TextColumn get operationType =>
      text().withDefault(const Constant('legacy_unknown'))();
  TextColumn get localOperationId => text().nullable().unique()();
  TextColumn get payloadJson => text().withDefault(const Constant('{}'))();
  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();
  TextColumn get status => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  TextColumn get remoteIntentId => text().nullable()();
  TextColumn get remoteSaleId => text().nullable()();
  TextColumn get proposalJson => text().nullable()();
  IntColumn get proposalRevision => integer().withDefault(const Constant(0))();
  TextColumn get confirmationToken => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

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
    LocalSalesTable,
    LocalSaleItemsTable,
    ClientsTable,
    ClientSnapshotEntriesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from == 1 && to == 5) {
        // 008B's sync_outbox is deliberately absent from this migration: the
        // v1 table and all of its rows must remain untouched.
        await migrator.createTable(categoriesTable);
        await migrator.createTable(productsTable);
        await migrator.createTable(dashboardSnapshotsTable);
        await migrator.createTable(syncCollectionsTable);
        await migrator.createTable(syncLocksTable);
        await _upgradeOutboxFromV3(migrator);
        await _upgradeToV5(migrator);
        return;
      }

      if (from == 2 && to == 5) {
        await migrator.createTable(syncLocksTable);
        await _upgradeOutboxFromV3(migrator);
        await _upgradeToV5(migrator);
        return;
      }

      if (from == 3 && to == 5) {
        await _upgradeOutboxFromV3(migrator);
        await _upgradeToV5(migrator);
        return;
      }

      if (from == 4 && to == 5) {
        await _upgradeToV5(migrator);
        return;
      }

      throw StateError('Migração de schema $from para $to não implementada.');
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'CREATE INDEX IF NOT EXISTS sync_outbox_eligibility '
        'ON sync_outbox(status, next_attempt_at, created_at, id)',
      );
    },
  );

  Future<void> _upgradeToV5(Migrator migrator) async {
    await migrator.createTable(clientsTable);
    await migrator.createTable(clientSnapshotEntriesTable);
  }

  Future<void> _upgradeOutboxFromV3(Migrator migrator) async {
    // SQLite cannot add a UNIQUE column in-place. Add nullable/defaulted
    // columns first so every legacy row remains valid, then create the index.
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN client_request_id TEXT NULL',
    );
    await customStatement(
      "ALTER TABLE sync_outbox ADD COLUMN operation_type TEXT NOT NULL DEFAULT 'legacy_unknown'",
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN local_operation_id TEXT NULL',
    );
    await customStatement(
      "ALTER TABLE sync_outbox ADD COLUMN payload_json TEXT NOT NULL DEFAULT '{}'",
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN payload_version INTEGER NOT NULL DEFAULT 1',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN attempts INTEGER NOT NULL DEFAULT 0',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN next_attempt_at INTEGER NULL',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN last_error TEXT NULL',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN remote_intent_id TEXT NULL',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN remote_sale_id TEXT NULL',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN proposal_json TEXT NULL',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN proposal_revision INTEGER NOT NULL DEFAULT 0',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN confirmation_token TEXT NULL',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN created_at INTEGER NULL',
    );
    await customStatement(
      'ALTER TABLE sync_outbox ADD COLUMN updated_at INTEGER NULL',
    );
    await customStatement(
      'CREATE UNIQUE INDEX sync_outbox_client_request_id_unique '
      'ON sync_outbox(client_request_id)',
    );
    await customStatement(
      'CREATE UNIQUE INDEX sync_outbox_local_operation_id_unique '
      'ON sync_outbox(local_operation_id)',
    );
    await migrator.createTable(localSalesTable);
    await migrator.createTable(localSaleItemsTable);
  }

  Future<int> pendingOutboxCount() async {
    final entries =
        await (select(syncOutbox)..where(
              (entry) =>
                  entry.status.equals('pending') |
                  entry.status.equals('syncing') |
                  entry.status.equals('failed_retryable') |
                  entry.status.equals('failed_permanent') |
                  entry.status.equals('requires_acceptance'),
            ))
            .get();
    return entries.length;
  }

  Selectable<StoredProduct> activeProducts() =>
      select(productsTable)..where((product) => product.deletedAt.isNull());

  Stream<List<StoredProduct>> watchActiveProducts() => activeProducts().watch();

  Stream<List<StoredClient>> watchClients() =>
      (select(clientsTable)..orderBy([
            (client) => OrderingTerm.asc(client.name),
            (client) => OrderingTerm.asc(client.id),
          ]))
          .watch();

  Stream<StoredDashboardSnapshot?> watchDashboardSnapshot(String scopeKey) =>
      (select(dashboardSnapshotsTable)
            ..where((snapshot) => snapshot.scopeKey.equals(scopeKey)))
          .watchSingleOrNull();

  Future<StoredSyncCollection?> readSyncCollection(String collection) =>
      (select(
        syncCollectionsTable,
      )..where((row) => row.collection.equals(collection))).getSingleOrNull();
}
