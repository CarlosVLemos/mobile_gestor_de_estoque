import 'package:drift/drift.dart';

import '../sync/sync_collection.dart';
import 'app_database.dart';

/// Compartilha o MESMO AppDatabase usado pela lease da engine.
class DriftSyncCheckpointStore {
  DriftSyncCheckpointStore(this.database);

  final AppDatabase database;

  Future<SyncCheckpoint> read(String collection) async {
    final row = await (database.select(database.syncCheckpointsTable)
          ..where((row) => row.collectionName.equals(collection)))
        .getSingleOrNull();
    return SyncCheckpoint(
      lastSyncedAt: row?.lastSyncedAt,
      cursor: row?.cursor,
    );
  }

  /// Chamado por SyncCollection.commitPage dentro da proteção da engine.
  /// Nenhum download ou efeito externo deve ocorrer em writeData.
  Future<void> commitPage({
    required String collection,
    required SyncCheckpoint checkpoint,
    required Future<void> Function() writeData,
  }) {
    return database.transaction(() async {
      await writeData();
      await database.into(database.syncCheckpointsTable).insertOnConflictUpdate(
        SyncCheckpointsTableCompanion.insert(
          collectionName: collection,
          lastSyncedAt: Value(checkpoint.lastSyncedAt),
          cursor: Value(checkpoint.cursor),
        ),
      );
    });
  }
}
