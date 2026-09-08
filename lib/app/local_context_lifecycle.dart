import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/data_purge_service.dart';
import '../core/database/database_factory.dart';
import '../core/sync/sync_lifecycle.dart';
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

final syncLifecycleProvider = Provider<SyncLifecycle>((ref) {
  return const NoopSyncLifecycle();
});

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
