import 'sync_exception.dart';

enum SyncStatus { idle, syncing, succeeded, failed, cancelled }

enum SyncTrigger { bootstrap, resumed, manual }

enum SyncOutcome { succeeded, failed, cancelled, busy, throttled }

class SyncState {
  const SyncState({
    this.status = SyncStatus.idle,
    this.collection,
    this.completedPages = 0,
    this.failureKind,
    this.completedCollections = const {},
    this.accessDenied = false,
  });

  final SyncStatus status;
  final String? collection;
  final int completedPages;
  final SyncFailureKind? failureKind;
  final Set<String> completedCollections;
  final bool accessDenied;
}
