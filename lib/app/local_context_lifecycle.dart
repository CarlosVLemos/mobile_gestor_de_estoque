import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/data_purge_service.dart';
import '../core/database/database_factory.dart';
import '../core/sync/context_sync_lifecycle.dart';
import '../core/sync/sync_lifecycle.dart';
import '../core/sync/sync_collection.dart';
import '../core/sync/sync_engine.dart';
import '../core/sync/sync_lock.dart';
import '../core/database/app_database.dart';
import '../core/database/drift_sync_lease_store.dart';
import '../core/network/api_client.dart';
import '../features/catalog/data/remote/product_remote_data_source.dart';
import '../features/catalog/data/sync/product_sync_collection.dart';
import '../features/dashboard/data/remote/dashboard_remote_data_source.dart';
import '../features/dashboard/data/sync/dashboard_sync_collection.dart';
import '../features/catalog/presentation/controllers/catalog_controller.dart';
import '../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../features/sales/presentation/controllers/pending_sales_controller.dart';
import '../features/sales/presentation/controllers/sales_controller.dart';
import '../features/settings/presentation/controllers/operational_context_controller.dart';
import 'shell/shell_profile.dart';

final databaseFactoryProvider = Provider<DatabaseFactory>((ref) {
  final factory = DatabaseFactory();
  ref.onDispose(() {
    // App teardown cannot await provider disposal, but normal logout/expiry
    // always awaits this close through DataPurgeService.
    factory.closeActive();
  });
  return factory;
});

final contextSyncLifecycleProvider = Provider<ContextSyncLifecycle>(
  (ref) => ContextSyncLifecycle(),
);

/// The current database exists only after authentication opened its scoped
/// context. Feature repositories and collections never fall back to fixtures.
final operationalDatabaseProvider = Provider<AppDatabase?>((ref) => ref.watch(databaseFactoryProvider).activeDatabase);

final contextSyncEngineProvider = Provider<SyncEngine?>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final context = ref.watch(databaseFactoryProvider).activeContext;
  if (database == null || context == null) return null;
  final now = DateTime.now();
  final goalMonth = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
  final scopeKey = 'day:$goalMonth:1';
  final api = ref.watch(apiClientProvider);
  final engine = SyncEngine(
    context: context,
    collections: <SyncCollection>[
      ProductSyncCollection(database: database, remote: ProductRemoteDataSource(api)),
      DashboardSyncCollection(database: database, remote: DashboardRemoteDataSource(api), scopeKey: scopeKey, goalMonth: goalMonth),
    ],
    lock: SyncLock(),
    leaseStore: DriftSyncLeaseStore(database: database),
  );
  ref.watch(contextSyncLifecycleProvider).register(engine);
  return engine;
});

/// 008B's teardown boundary, backed by engines registered for each context.
final syncLifecycleProvider = Provider<SyncLifecycle>(
  (ref) => ref.watch(contextSyncLifecycleProvider),
);

final contextStateInvalidatorProvider = Provider<ContextStateInvalidator>((
  ref,
) {
  return () {
    ref.invalidate(catalogControllerProvider);
    ref.invalidate(dashboardControllerProvider);
    ref.invalidate(salesControllerProvider);
    ref.invalidate(pendingSalesProvider);
    ref.invalidate(operationalContextControllerProvider);
    ref.invalidate(shellDisplayNameControllerProvider);
    ref.invalidate(contextSyncEngineProvider);
    ref.invalidate(operationalDatabaseProvider);
  };
});

final dataPurgeServiceProvider = Provider<DataPurgeService>((ref) {
  return DataPurgeService(
    ref.watch(databaseFactoryProvider),
    ref.watch(syncLifecycleProvider),
    ContextCacheCleaner(),
    ref.watch(contextStateInvalidatorProvider),
  );
});
