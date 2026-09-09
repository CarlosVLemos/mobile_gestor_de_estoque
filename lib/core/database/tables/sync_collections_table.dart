import 'package:drift/drift.dart';

@DataClassName('StoredSyncCollection')
class SyncCollectionsTable extends Table {
  @override
  String get tableName => 'sync_collections';

  TextColumn get collection => text()();
  TextColumn get mode => text()();
  TextColumn get cursor => text().nullable()();
  TextColumn get checkpoint => text().nullable()();
  TextColumn get targetCheckpoint => text().nullable()();
  TextColumn get revision => text().nullable()();
  DateTimeColumn get lastSuccessAt => dateTime().nullable()();
  BoolColumn get isBootstrapped => boolean()();
  IntColumn get totalReceived => integer()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {collection};
}
