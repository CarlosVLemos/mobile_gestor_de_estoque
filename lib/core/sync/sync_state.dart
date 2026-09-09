import 'sync_exception.dart';

enum SyncStatus { idle, syncing, succeeded, failed, cancelled, stopping, stopped }
enum SyncTrigger { startup, resumed, manual, connectivity, background }
enum SyncOutcome { succeeded, failed, cancelled, busy, throttled, stopped }

class SyncState {
  const SyncState({
    this.status = SyncStatus.idle,
    this.collection,
    this.completedPages = 0,
    this.failureKind,
    this.completedCollections = const {},
  });

  final SyncStatus status;
  final String? collection;
  final int completedPages;
  final SyncFailureKind? failureKind;
  final Set<String> completedCollections;
}
