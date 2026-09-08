import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_lifecycle_observer.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/sync/sync_state.dart';

/// Registra lifecycle somente quando uma engine autenticada foi composta.
class ReadSyncScope extends ConsumerWidget {
  const ReadSyncScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(syncEngineProvider);
    return _LifecycleBinding(engine: engine, child: child);
  }
}

class _LifecycleBinding extends StatefulWidget {
  const _LifecycleBinding({required this.engine, required this.child});

  final SyncEngine? engine;
  final Widget child;

  @override
  State<_LifecycleBinding> createState() => _LifecycleBindingState();
}

class _LifecycleBindingState extends State<_LifecycleBinding> {
  SyncLifecycleObserver? _observer;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    final engine = widget.engine;
    if (engine == null) return;
    _observer = SyncLifecycleObserver(engine);
    WidgetsBinding.instance.addObserver(_observer!);
    scheduleMicrotask(() {
      if (mounted && identical(engine, widget.engine)) {
        unawaited(engine.sync(trigger: SyncTrigger.bootstrap));
      }
    });
  }

  void _detach() {
    final observer = _observer;
    if (observer != null) {
      WidgetsBinding.instance.removeObserver(observer);
      observer.engine.cancel();
      _observer = null;
    }
  }

  @override
  void didUpdateWidget(covariant _LifecycleBinding oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.engine, widget.engine)) {
      _detach();
      _attach();
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
