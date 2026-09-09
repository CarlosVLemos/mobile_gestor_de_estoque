import '../../../../core/database/app_database.dart';
import '../../../../core/database/drift_sync_checkpoint_store.dart';
import '../../../../core/sync/sync_collection.dart';
import '../remote/dashboard_remote_data_source.dart';

class DashboardSyncCollection implements SyncCollection, CancellableSyncCollection {
  DashboardSyncCollection({required this.database, required this.remote, required this.scopeKey, this.groupBy = 'day', required this.goalMonth, this.page = 1}) : _store = DriftSyncCheckpointStore(database);
  final AppDatabase database; final DashboardRemoteDataSource remote; final String scopeKey, groupBy, goalMonth; final int page; final DriftSyncCheckpointStore _store;
  @override String get name => 'dashboard:$scopeKey';
  @override Future<SyncCheckpoint> readCheckpoint() => _store.read(name);
  @override Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async { final snapshot = await remote.fetch(groupBy: groupBy, goalMonth: goalMonth, page: page); return _DashboardPage(snapshot, SyncCheckpoint(mode: 'snapshot', revision: snapshot.revision, isBootstrapped: true, totalReceived: 1)); }
  @override Future<void> commitPage(SyncPage value) { if (value is! _DashboardPage) throw ArgumentError.value(value, 'page'); final snapshot = value.snapshot; return _store.commitPage(collection: name, checkpoint: value.checkpoint, writeData: () => database.into(database.dashboardSnapshotsTable).insertOnConflictUpdate(DashboardSnapshotsTableCompanion.insert(scopeKey: scopeKey, period: snapshot.period, groupBy: groupBy, page: page, revision: snapshot.revision, generatedAt: snapshot.generatedAt, referenceDate: snapshot.referenceDate, webDashboardUrl: snapshot.webDashboardUrl, canViewFinancial: snapshot.canViewFinancial, payloadJson: snapshot.payloadJson))); }
  @override void cancelPendingRequest() => remote.cancelPendingRequest();
}
class _DashboardPage implements SyncPage { const _DashboardPage(this.snapshot, this.checkpoint); final RemoteDashboardSnapshot snapshot; @override final SyncCheckpoint checkpoint; @override bool get hasMore => false; }
