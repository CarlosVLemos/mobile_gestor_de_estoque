import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/database/app_database.dart';
import '../../core/database/data_purge_service.dart';
import '../../core/database/database_factory.dart';
import '../../core/database/drift_sync_lease_store.dart';
import '../../core/database/local_context.dart';
import '../../core/network/api_client.dart';
import '../../core/sync/context_sync_lifecycle.dart';
import '../../core/sync/sync_collection.dart';
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_lifecycle.dart';
import '../../core/sync/sync_lock.dart';
import '../../features/catalog/data/remote/product_remote_data_source.dart';
import '../../features/catalog/data/sync/product_sync_collection.dart';
import '../../features/catalog/presentation/controllers/catalog_controller.dart';
import '../../features/dashboard/data/remote/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/sync/dashboard_sync_collection.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/sales/application/outbox_processor.dart';
import '../../features/sales/presentation/controllers/pending_sales_controller.dart';
import '../../features/sales/presentation/controllers/sales_controller.dart';
import '../../features/sales/sales_sync_composition.dart';
import '../../features/settings/presentation/controllers/operational_context_controller.dart';
import '../shell/shell_profile.dart';

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

class OperationalReadAccess {
  const OperationalReadAccess({
    required this.hasCatalogFeature,
    required this.canViewProducts,
    required this.canViewFinancialMetrics,
    required this.hasSalesFeature,
    required this.canCreateSales,
  });

  final bool hasCatalogFeature;
  final bool canViewProducts;
  final bool canViewFinancialMetrics;
  final bool hasSalesFeature;
  final bool canCreateSales;
}

final activeSyncContextProvider = StateProvider<LocalContext?>((ref) => null);
final activeAccessTokenProvider = StateProvider<String?>((ref) => null);
final operationalReadAccessProvider = StateProvider<OperationalReadAccess?>(
  (ref) => null,
);

/// The current database exists only after authentication opened its scoped
/// context. Feature repositories and collections never fall back to fixtures.
final operationalDatabaseProvider = Provider<AppDatabase?>(
  (ref) => ref.watch(databaseFactoryProvider).activeDatabase,
);

/// Context-bound sales worker. It is shared by automatic draining and the
/// future explicit acceptance UI, without capturing [Ref] inside the worker.
final contextOutboxProcessorProvider = Provider<OutboxProcessor?>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final accessToken = ref.watch(activeAccessTokenProvider);
  if (database == null || accessToken == null || accessToken.isEmpty) {
    return null;
  }
  final processor = buildSalesOutboxProcessor(
    database: database,
    api: ref.watch(apiClientProvider),
    accessToken: accessToken,
  );
  ref.onDispose(processor.cancel);
  return processor;
});

final contextSyncEngineProvider = Provider<SyncEngine?>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final context = ref.watch(databaseFactoryProvider).activeContext;
  final activeContext = ref.watch(activeSyncContextProvider);
  final accessToken = ref.watch(activeAccessTokenProvider);
  if (database == null ||
      context == null ||
      context != activeContext ||
      accessToken == null ||
      accessToken.isEmpty) {
    return null;
  }
  final lifecycle = ref.watch(contextSyncLifecycleProvider);
  final current = lifecycle.engineFor(context);
  if (current != null) return current;
  final access = ref.watch(operationalReadAccessProvider);
  final now = DateTime.now();
  final goalMonth =
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
  final scopeKey = 'day:$goalMonth:1';
  final api = ref.watch(apiClientProvider);
  final engine = SyncEngine(
    context: context,
    collections: <SyncCollection>[
      if (access?.hasCatalogFeature == true &&
          access?.canViewProducts == true)
        ProductSyncCollection(
          database: database,
          remote: ProductRemoteDataSource(api, accessToken: accessToken),
        ),
      DashboardSyncCollection(
        database: database,
        remote: DashboardRemoteDataSource(api, accessToken: accessToken),
        scopeKey: scopeKey,
        goalMonth: goalMonth,
      ),
    ],
    lock: SyncLock(),
    leaseStore: DriftSyncLeaseStore(database: database),
    outboxDrainer: ref.watch(contextOutboxProcessorProvider),
  );
  lifecycle.register(engine);
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
    ref.invalidate(contextOutboxProcessorProvider);
    ref.invalidate(operationalDatabaseProvider);
    ref.read(activeSyncContextProvider.notifier).state = null;
    ref.read(activeAccessTokenProvider.notifier).state = null;
    ref.read(operationalReadAccessProvider.notifier).state = null;
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
