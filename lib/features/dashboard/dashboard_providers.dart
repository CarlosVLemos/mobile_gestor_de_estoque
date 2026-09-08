import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/network/api_client.dart';
import '../../core/sync/sync_collection.dart';
import 'application/use_cases/load_dashboard_use_case.dart';
import 'data/local/dashboard_local_store.dart';
import 'data/remote/dashboard_remote_data_source.dart';
import 'data/repositories/drift_dashboard_repository.dart';
import 'data/repositories/fixture_dashboard_repository.dart';
import 'data/sync/dashboard_sync_collection.dart';
import 'domain/repositories/dashboard_repository.dart';

final dashboardFinancialAccessProvider = Provider<bool>((ref) => false);

/// Ausência de contrato mantém a coleção remota desligada, nunca usa fixture.
final dashboardRemoteDecoderProvider = Provider<DashboardRemoteDecoder?>((ref) => null);

final dashboardSyncCollectionProvider = Provider<SyncCollection?>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final decoder = ref.watch(dashboardRemoteDecoderProvider);
  if (database == null || decoder == null) return null;
  return DashboardSyncCollection(
    local: DashboardLocalStore(database),
    remote: DashboardRemoteDataSource(ref.watch(apiClientProvider), decoder),
  );
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  if (database != null) {
    return DriftDashboardRepository(
      DashboardLocalStore(database),
      canViewFinancial: ref.watch(dashboardFinancialAccessProvider),
    );
  }
  return const FixtureDashboardRepository();
});

final dashboardOverviewStreamProvider = StreamProvider.autoDispose<DashboardLoadResult>((ref) {
  return ref.watch(loadDashboardUseCaseProvider).watch();
});

final loadDashboardUseCaseProvider = Provider<LoadDashboardUseCase>((ref) {
  return LoadDashboardUseCase(ref.watch(dashboardRepositoryProvider));
});
