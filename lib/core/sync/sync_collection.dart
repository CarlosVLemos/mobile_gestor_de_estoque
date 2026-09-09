/// Opaque state supplied by, and persisted for, a registered collection.
class SyncCheckpoint {
  const SyncCheckpoint({
    this.mode,
    this.cursor,
    this.checkpoint,
    this.targetCheckpoint,
    this.revision,
    this.isBootstrapped = false,
    this.totalReceived = 0,
  });

  final String? mode;
  final String? cursor;
  final String? checkpoint;
  final String? targetCheckpoint;
  final String? revision;
  final bool isBootstrapped;
  final int totalReceived;
}

abstract interface class SyncPage {
  bool get hasMore;
  SyncCheckpoint get checkpoint;
}

/// Feature code owns remote protocol and data mapping. [commitPage] must
/// persist data and promote the page checkpoint atomically, after the data.
abstract interface class SyncCollection {
  String get name;
  Future<SyncCheckpoint> readCheckpoint();
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint);
  Future<void> commitPage(SyncPage page);
}

/// Optional transport boundary. Implementations can cancel an in-flight HTTP
/// request without exposing Dio or any server-specific detail to the engine.
abstract interface class CancellableSyncCollection {
  void cancelPendingRequest();
}
