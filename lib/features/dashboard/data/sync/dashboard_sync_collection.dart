import '../../../../core/database/drift_sync_checkpoint_store.dart';
import '../../../../core/sync/sync_collection.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../local/dashboard_local_store.dart';
import '../remote/dashboard_remote_data_source.dart';

class DashboardSyncCollection implements SyncCollection {
  DashboardSyncCollection({required this.local, required this.remote});

  final DashboardLocalStore local;
  final DashboardRemoteDataSource remote;

  @override
  String get name => 'dashboard';

  @override
  Future<SyncCheckpoint> readCheckpoint() => DriftSyncCheckpointStore(local.database).read(name);

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async => _DashboardPage(await remote.fetch());

  @override
  Future<void> commitPage(SyncPage page) {
    if (page is! _DashboardPage) throw ArgumentError('Página de outra coleção.');
    return DriftSyncCheckpointStore(local.database).commitPage(
      collection: name,
      checkpoint: page.checkpoint,
      writeData: () => local.replace(page.overview),
    );
  }
}

class _DashboardPage implements SyncPage {
  _DashboardPage(this.overview);

  final DashboardOverview overview;
  @override
  bool get hasMore => false;
  // Dashboard sempre é snapshot completo, sem cursor/timestamp remoto inventado.
  @override
  SyncCheckpoint get checkpoint => const SyncCheckpoint();
}
