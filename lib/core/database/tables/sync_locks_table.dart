import 'package:drift/drift.dart';

/// A lease is scoped to the physical database of one authenticated context.
/// Instants are UTC epoch milliseconds, never presentation-local timestamps.
@DataClassName('StoredSyncLock')
class SyncLocksTable extends Table {
  @override
  String get tableName => 'sync_locks';

  TextColumn get name => text()();
  TextColumn get ownerId => text()();
  IntColumn get acquiredAt => integer()();
  IntColumn get expiresAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {name};
}
