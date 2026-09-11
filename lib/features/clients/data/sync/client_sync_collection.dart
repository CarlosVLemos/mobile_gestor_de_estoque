import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/drift_sync_checkpoint_store.dart';
import '../../../../core/sync/sync_collection.dart';
import '../remote/client_remote_data_source.dart';

class ClientSyncCollection
    implements SyncCollection, CancellableSyncCollection {
  ClientSyncCollection({required this.database, required this.remote})
    : _store = DriftSyncCheckpointStore(database);

  static const collectionName = 'clients';
  final AppDatabase database;
  final ClientRemoteDataSource remote;
  final DriftSyncCheckpointStore _store;

  @override
  String get name => collectionName;

  @override
  Future<SyncCheckpoint> readCheckpoint() => _store.read(name);

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint saved) async {
    final response = await remote.fetch(cursor: saved.cursor);
    final upperBound = response.snapshotUpperBoundId.toString();
    if (saved.targetCheckpoint != null &&
        saved.targetCheckpoint != upperBound) {
      throw const FormatException(
        'Snapshot de clientes mudou durante a paginação.',
      );
    }
    final continuing = saved.cursor != null;
    return _ClientPage(
      response: response,
      isFirstPage: !continuing,
      checkpoint: SyncCheckpoint(
        mode: 'snapshot',
        cursor: response.hasMore ? response.nextCursor : null,
        targetCheckpoint: response.hasMore ? upperBound : null,
        checkpoint: response.hasMore ? saved.checkpoint : upperBound,
        isBootstrapped: !response.hasMore || saved.isBootstrapped,
        totalReceived:
            (continuing ? saved.totalReceived : 0) + response.clients.length,
      ),
    );
  }

  @override
  Future<void> commitPage(SyncPage page) {
    if (page is! _ClientPage) throw ArgumentError.value(page, 'page');
    final upperBound = page.response.snapshotUpperBoundId;
    return _store.commitPage(
      collection: name,
      checkpoint: page.checkpoint,
      writeData: () async {
        if (page.isFirstPage) {
          await database.delete(database.clientSnapshotEntriesTable).go();
        }
        await database.batch((batch) {
          batch.insertAllOnConflictUpdate(
            database.clientsTable,
            page.response.clients.map(
              (client) => ClientsTableCompanion.insert(
                id: client.id,
                name: client.name,
                city: Value(client.city),
                state: Value(client.state),
              ),
            ),
          );
          batch.insertAll(
            database.clientSnapshotEntriesTable,
            page.response.clients.map(
              (client) => ClientSnapshotEntriesTableCompanion.insert(
                snapshotUpperBoundId: upperBound,
                clientId: client.id,
              ),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        });
        if (!page.hasMore) {
          await database.customStatement(
            'DELETE FROM clients WHERE id NOT IN '
            '(SELECT client_id FROM client_snapshot_entries '
            'WHERE snapshot_upper_bound_id = ?)',
            [upperBound],
          );
          await database.delete(database.clientSnapshotEntriesTable).go();
        }
      },
    );
  }

  @override
  void cancelPendingRequest() => remote.cancelPendingRequest();
}

class _ClientPage implements SyncPage {
  const _ClientPage({
    required this.response,
    required this.isFirstPage,
    required this.checkpoint,
  });

  final RemoteClientPage response;
  final bool isFirstPage;
  @override
  final SyncCheckpoint checkpoint;
  @override
  bool get hasMore => response.hasMore;
}
