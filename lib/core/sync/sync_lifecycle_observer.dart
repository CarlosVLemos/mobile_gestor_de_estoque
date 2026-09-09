import 'dart:async';

import 'package:flutter/widgets.dart';

import 'sync_engine.dart';
import 'sync_state.dart';

/// Context composition may attach this while its engine is active. The engine
/// itself applies the resumed cooldown; manual refresh always bypasses it.
class SyncLifecycleObserver extends WidgetsBindingObserver {
  SyncLifecycleObserver(this.engine);

  final SyncEngine engine;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(engine.sync(trigger: SyncTrigger.resumed));
    }
  }
}
