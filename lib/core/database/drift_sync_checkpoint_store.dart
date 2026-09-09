import 'package:drift/drift.dart';

import '../sync/sync_collection.dart';
import 'app_database.dart';

/// Adapter shared by a collection's data transaction and its opaque state.
class DriftSyncCheckpointStore {
  DriftSyncCheckpointStore(this.database);

  final AppDatabase database;

  Future<SyncCheckpoint> read(String collection) async {
    final row = await database.readSyncCollection(collection);
    return SyncCheckpoint(
      mode: row?.mode,
      cursor: row?.cursor,
      checkpoint: row?.checkpoint,
      targetCheckpoint: row?.targetCheckpoint,
      revision: row?.revision,
      isBootstrapped: row?.isBootstrapped ?? false,
      totalReceived: row?.totalReceived ?? 0,
    );
  }

  /// [writeData] and the checkpoint are one SQLite transaction. The data is
  /// written first; any failure prevents promotion of the opaque cursor.
  Future<void> commitPage({
    required String collection,
    required SyncCheckpoint checkpoint,
    required Future<void> Function() writeData,
  }) {
    return database.transaction(() async {
      await writeData();
      await database.into(database.syncCollectionsTable).insertOnConflictUpdate(
        SyncCollectionsTableCompanion.insert(
          collection: collection,
          mode: checkpoint.mode ?? 'bootstrap',
          cursor: Value(checkpoint.cursor),
          checkpoint: Value(checkpoint.checkpoint),
          targetCheckpoint: Value(checkpoint.targetCheckpoint),
          revision: Value(checkpoint.revision),
          lastSuccessAt: Value(DateTime.now().toUtc()),
          isBootstrapped: checkpoint.isBootstrapped,
          totalReceived: checkpoint.totalReceived,
          lastError: const Value(null),
        ),
      );
    });
  }
}
