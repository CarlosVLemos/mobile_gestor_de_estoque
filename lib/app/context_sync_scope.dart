import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/sync/sync_engine.dart';
import '../core/sync/sync_lifecycle_observer.dart';
import 'local_context_lifecycle.dart';

/// Attaches only foreground lifecycle triggers to the engine for the active
/// authenticated context. Context teardown itself remains owned by 008B.
class ContextSyncScope extends ConsumerStatefulWidget {
  const ContextSyncScope({required this.child, super.key});
  final Widget child;

  @override
  ConsumerState<ContextSyncScope> createState() => _ContextSyncScopeState();
}

class _ContextSyncScopeState extends ConsumerState<ContextSyncScope> {
  SyncEngine? _engine;
  SyncLifecycleObserver? _observer;

  @override
  Widget build(BuildContext context) {
    final next = ref.watch(contextSyncEngineProvider);
    if (!identical(next, _engine)) {
      _detach();
      _engine = next;
      if (next != null) {
        _observer = SyncLifecycleObserver(next);
        WidgetsBinding.instance.addObserver(_observer!);
      }
    }
    return widget.child;
  }

  void _detach() {
    final observer = _observer;
    if (observer != null) WidgetsBinding.instance.removeObserver(observer);
    _observer = null;
    _engine?.cancel();
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }
}
