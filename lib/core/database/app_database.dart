import 'package:drift/drift.dart';

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

@DriftDatabase(tables: [SyncOutbox])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (migrator) async => migrator.createAll());

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
}
