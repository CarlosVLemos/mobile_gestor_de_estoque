import 'sync_exception.dart';

abstract interface class SyncLeaseStore {
  Future<SyncLease?> tryAcquire();
}

abstract interface class SyncLease {
  /// Throws [SyncLeaseLost] if this execution no longer owns the lease.
  Future<void> renew();

  /// Verifies ownership around the local transaction containing the page and
  /// its checkpoint. It must not perform network work.
  Future<void> protect(Future<void> Function() write);

  /// Deletes only a row still owned by this execution.
  Future<void> release();
}
