enum SyncFailureKind { offline, unauthorized, forbidden, remote, invalidData, local, ownershipLost, stopping }

class SyncException implements Exception {
  const SyncException(this.kind);

  final SyncFailureKind kind;
}

class SyncLeaseLost extends SyncException {
  const SyncLeaseLost() : super(SyncFailureKind.ownershipLost);
}

class SyncStopTimeoutException extends SyncException {
  const SyncStopTimeoutException() : super(SyncFailureKind.stopping);
}
