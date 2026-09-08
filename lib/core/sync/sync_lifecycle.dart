import '../database/local_context.dart';

/// Boundary for the future SyncEngine. 008B must await this boundary before a
/// database is closed; until the engine is introduced, it is intentionally a
/// no-op rather than an implicit background process.
abstract interface class SyncLifecycle {
  Future<void> stop(LocalContext context);
}

class NoopSyncLifecycle implements SyncLifecycle {
  const NoopSyncLifecycle();

  @override
  Future<void> stop(LocalContext context) async {}
}
