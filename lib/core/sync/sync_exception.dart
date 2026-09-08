enum SyncFailureKind { offline, unauthorized, forbidden, remote, invalidData, local }

class SyncException implements Exception {
  const SyncException(this.kind);

  final SyncFailureKind kind;
}
