import 'package:drift/drift.dart';

@DataClassName('StoredSyncLock')
class SyncLocksTable extends Table {
  @override
  String get tableName => 'sync_locks';

  TextColumn get name => text()();
  TextColumn get ownerId => text()();

  // Milissegundos UTC explícitos para comparações precisas de expiração.
  IntColumn get acquiredAt => integer()();
  IntColumn get expiresAt => integer()();

  @override
  Set<Column> get primaryKey => {name};
}
