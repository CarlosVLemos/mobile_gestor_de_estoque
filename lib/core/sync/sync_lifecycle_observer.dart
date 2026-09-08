import 'dart:async';

import 'package:flutter/widgets.dart';

import 'sync_engine.dart';
import 'sync_state.dart';

/// O responsável pelo contexto registra/remove este observer no binding.
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
