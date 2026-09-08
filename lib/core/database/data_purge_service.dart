import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../sync/sync_lifecycle.dart';
import 'database_factory.dart';
import 'local_context.dart';

typedef ContextStateInvalidator = void Function();
typedef PurgeObserver = void Function(PurgeStep step);

enum PurgeStep { syncStopped, databaseClosed, cacheCleared, stateInvalidated }

class ContextCacheCleaner {
  ContextCacheCleaner({DirectoryProvider? temporaryDirectory})
    : _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  final DirectoryProvider _temporaryDirectory;

  Future<void> clear(LocalContext context) async {
    final root = await _temporaryDirectory();
    final contextCache = Directory(
      path.join(root.path, 'arara_context_cache', context.cacheDirectoryName),
    );
    if (await contextCache.exists()) {
      await contextCache.delete(recursive: true);
    }
  }
}

/// Performs the irreversible-in-memory part of ending a session. It never
/// deletes the context database, including any pending outbox entries.
class DataPurgeService {
  DataPurgeService(
    this._databaseFactory,
    this._syncLifecycle,
    this._cacheCleaner,
    this._invalidateContextState, [
    this._observer,
  ]);

  final DatabaseFactory _databaseFactory;
  final SyncLifecycle _syncLifecycle;
  final ContextCacheCleaner _cacheCleaner;
  final ContextStateInvalidator _invalidateContextState;
  final PurgeObserver? _observer;

  Future<int> pendingOutboxCount() async =>
      _databaseFactory.activeDatabase?.pendingOutboxCount() ?? 0;

  Future<void> purge() async {
    final context = _databaseFactory.activeContext;
    if (context == null) return;

    await _syncLifecycle.stop(context);
    _observer?.call(PurgeStep.syncStopped);
    await _databaseFactory.closeActive();
    _observer?.call(PurgeStep.databaseClosed);
    await _cacheCleaner.clear(context);
    _observer?.call(PurgeStep.cacheCleared);
    _invalidateContextState();
    _observer?.call(PurgeStep.stateInvalidated);
  }
}
