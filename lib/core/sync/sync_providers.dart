import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_engine.dart';
import 'sync_state.dart';
import 'synchronize_use_case.dart';

/// A composição autenticada deve fornecer a engine do contexto isolado.
final syncEngineProvider = Provider<SyncEngine?>((ref) => null);

final synchronizeUseCaseProvider = Provider<SynchronizeUseCase>((ref) {
  return SynchronizeUseCase(ref.watch(syncEngineProvider));
});

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
