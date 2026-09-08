import 'package:drift/drift.dart';

@DataClassName('StoredSyncCheckpoint')
class SyncCheckpointsTable extends Table {
  @override
  String get tableName => 'sync_checkpoints';

  TextColumn get collectionName => text()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get cursor => text().nullable()();

  @override
  Set<Column> get primaryKey => {collectionName};
}
