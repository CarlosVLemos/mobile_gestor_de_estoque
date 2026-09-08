import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/database/drift_sync_lease_store.dart';
import '../../core/sync/sync_collection.dart';
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_lock.dart';
import '../../features/catalog/catalog_providers.dart';
import '../../features/dashboard/dashboard_providers.dart';

/// Timeouts HTTP atuais são 15s; TTL permite download e commit de uma página.
final readSyncLeaseTtlProvider = Provider<Duration>((ref) => const Duration(minutes: 2));

final readSyncEngineProvider = Provider<SyncEngine?>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  if (database == null) return null;
  final catalog = ref.watch(catalogSyncCollectionProvider);
  final dashboard = ref.watch(dashboardSyncCollectionProvider);
  final engine = SyncEngine(
    collections: <SyncCollection>[
      if (catalog != null) catalog,
      if (dashboard != null) dashboard,
    ],
    lock: SyncLock(),
    leaseStore: DriftSyncLeaseStore(database: database, ttl: ref.watch(readSyncLeaseTtlProvider)),
  );
  // O responsável pela sessão deve aguardar dispose ANTES de fechar o banco.
  ref.onDispose(() => unawaited(engine.dispose()));
  return engine;
});
