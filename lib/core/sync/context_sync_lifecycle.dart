import '../database/local_context.dart';
import 'sync_engine.dart';
import 'sync_lifecycle.dart';

/// Context composition registers its engine here before any trigger is wired.
/// A failed stop deliberately retains the entry, blocking a new engine for the
/// same context until a retry reaches a safe teardown point.
class ContextSyncLifecycle implements SyncLifecycle {
  final Map<LocalContext, SyncEngine> _engines = {};

  SyncEngine? engineFor(LocalContext context) => _engines[context];

  void register(SyncEngine engine) {
    final current = _engines[engine.context];
    if (current != null && !identical(current, engine)) {
      throw StateError('Já existe um SyncEngine ativo para este contexto.');
    }
    _engines[engine.context] = engine;
  }

  @override
  Future<void> stop(LocalContext context) async {
    final engine = _engines[context];
    if (engine == null) return;
    await engine.stop(context);
    _engines.remove(context);
  }
}
