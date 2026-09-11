import 'package:drift/drift.dart';

/// Durable membership of the client snapshot currently being downloaded.
/// Rows are removed only after the terminal page has reconciled [ClientsTable].
class ClientSnapshotEntriesTable extends Table {
  @override
  String get tableName => 'client_snapshot_entries';

  IntColumn get snapshotUpperBoundId => integer()();
  TextColumn get clientId => text()();

  @override
  Set<Column<Object>> get primaryKey => {snapshotUpperBoundId, clientId};
}
