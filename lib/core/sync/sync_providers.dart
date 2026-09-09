import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_engine.dart';
import 'sync_state.dart';

/// The authenticated context composition overrides this provider with its
/// registered engine. Keeping it nullable avoids opening an anonymous DB.
final syncEngineProvider = Provider<SyncEngine?>((ref) => null);

/// UI observes engine state only; it never reaches Drift or the transport.
final syncStateProvider = StreamProvider.autoDispose<SyncState>((ref) {
  final engine = ref.watch(syncEngineProvider);
  if (engine == null) return Stream.value(const SyncState());
  return Stream<SyncState>.multi((controller) {
    final subscription = engine.changes.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );
    controller.add(engine.state);
    controller.onCancel = subscription.cancel;
  });
});
