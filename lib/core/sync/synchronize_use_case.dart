import 'sync_engine.dart';
import 'sync_state.dart';

class SynchronizeUseCase {
  const SynchronizeUseCase(this.engine);

  final SyncEngine? engine;

  Future<SyncOutcome?> call() async => engine?.sync();
}
