import 'dart:async';

import '../database/local_context.dart';
import 'sync_collection.dart';
import 'sync_exception.dart';
import 'sync_lease.dart';
import 'sync_lifecycle.dart';
import 'sync_lock.dart';
import 'sync_state.dart';

/// Executes finite, ordered rounds for exactly one local user/tenant context.
class SyncEngine implements SyncLifecycle {
  SyncEngine({
    required this.context,
    required List<SyncCollection> collections,
    required this._lock,
    required this._leaseStore,
    DateTime Function()? now,
    this.resumeCooldown = const Duration(minutes: 5),
    this.stopTimeout = const Duration(seconds: 10),
    this.heartbeatInterval = defaultHeartbeatInterval,
  }) : _collections = List.unmodifiable(collections),
       _now = now ?? DateTime.now {
    if (collections.map((item) => item.name).toSet().length != collections.length) {
      throw ArgumentError('Coleções de sincronização devem ter nomes únicos.');
    }
  }

  static const defaultHeartbeatInterval = Duration(seconds: 30);
  final LocalContext context;
  final List<SyncCollection> _collections;
  final SyncLock _lock;
  final SyncLeaseStore _leaseStore;
  final DateTime Function() _now;
  final Duration resumeCooldown;
  final Duration stopTimeout;
  final Duration heartbeatInterval;
  final _changes = StreamController<SyncState>.broadcast();

  SyncState _state = const SyncState();
  DateTime? _lastFinishedAt;
  Future<SyncOutcome>? _activeRun;
  Future<void>? _stopInFlight;
  bool _cancelled = false;
  bool _stopping = false;
  bool _stopped = false;
  bool _ownershipLost = false;

  SyncState get state => _state;
  Stream<SyncState> get changes => _changes.stream;
  bool get isStopping => _stopping;
  bool get isStopped => _stopped;

  void cancel() {
    _cancelled = true;
    for (final collection in _collections) {
      if (collection case CancellableSyncCollection cancellable) {
        cancellable.cancelPendingRequest();
      }
    }
  }

  void _emit(SyncState value) {
    _state = value;
    if (!_changes.isClosed) _changes.add(value);
  }

  Future<SyncOutcome> sync({SyncTrigger trigger = SyncTrigger.manual}) {
    if (_stopping || _stopped) return Future.value(SyncOutcome.stopped);
    if (_activeRun != null || !_lock.tryAcquire()) return Future.value(SyncOutcome.busy);
    final lastFinished = _lastFinishedAt;
    if (trigger == SyncTrigger.resumed &&
        lastFinished != null &&
        _now().difference(lastFinished) <= resumeCooldown) {
      _lock.release();
      return Future.value(SyncOutcome.throttled);
    }
    late final Future<SyncOutcome> run;
    run = _run().whenComplete(() {
      if (identical(_activeRun, run)) _activeRun = null;
      _lock.release();
    });
    _activeRun = run;
    return run;
  }

  Future<SyncOutcome> _run() async {
    _cancelled = false;
    _ownershipLost = false;
    SyncLease? lease;
    _HeartbeatWorker? heartbeat;
    var pages = 0;
    var activeCollection = <String>{};
    var outcome = SyncOutcome.failed;
    SyncFailureKind? failure;
    try {
      lease = await _leaseStore.tryAcquire();
      if (lease == null) {
        outcome = SyncOutcome.busy;
        return outcome;
      }
      _emit(const SyncState(status: SyncStatus.syncing));
      heartbeat = _HeartbeatWorker(
        interval: heartbeatInterval,
        onTick: () async {
          try {
            await lease!.renew();
          } on SyncLeaseLost {
            _ownershipLost = true;
            _cancelled = true;
          } catch (_) {
            _ownershipLost = true;
            _cancelled = true;
          }
        },
      );
      for (final collection in _collections) {
        if (_cancelled) break;
        final completed = await _runCollection(collection, lease, pages);
        pages += completed.pages;
        if (completed.finished) activeCollection.add(collection.name);
        if (!completed.finished) break;
      }
      outcome = _cancelled ? SyncOutcome.cancelled : SyncOutcome.succeeded;
    } on SyncException catch (error) {
      failure = error.kind;
      outcome = _cancelled ? SyncOutcome.cancelled : SyncOutcome.failed;
    } catch (_) {
      failure = SyncFailureKind.local;
      outcome = _cancelled ? SyncOutcome.cancelled : SyncOutcome.failed;
    } finally {
      heartbeat?.stop();
      await heartbeat?.done;
      try {
        await lease?.release();
      } catch (_) {
        outcome = _cancelled ? SyncOutcome.cancelled : SyncOutcome.failed;
        failure ??= SyncFailureKind.local;
      }
      if (outcome != SyncOutcome.busy) {
        _lastFinishedAt = _now();
        _emit(SyncState(
          status: switch (outcome) {
            SyncOutcome.succeeded => SyncStatus.succeeded,
            SyncOutcome.cancelled => SyncStatus.cancelled,
            _ => SyncStatus.failed,
          },
          completedPages: pages,
          failureKind: failure,
          completedCollections: Set.unmodifiable(activeCollection),
        ));
      }
    }
    return outcome;
  }

  Future<_CollectionResult> _runCollection(
    SyncCollection collection,
    SyncLease lease,
    int priorPages,
  ) async {
    var checkpoint = await collection.readCheckpoint();
    var pages = 0;
    while (!_cancelled) {
      await lease.renew();
      if (_ownershipLost || _cancelled) break;
      _emit(SyncState(
        status: SyncStatus.syncing,
        collection: collection.name,
        completedPages: priorPages + pages,
      ));
      final page = await collection.fetchPage(checkpoint);
      if (_ownershipLost || _cancelled) break;
      await lease.protect(() async {
        if (_ownershipLost || _cancelled) throw const SyncLeaseLost();
        await collection.commitPage(page);
      });
      checkpoint = page.checkpoint;
      pages++;
      if (!page.hasMore) return _CollectionResult(pages, true);
    }
    return _CollectionResult(pages, false);
  }

  @override
  Future<void> stop(LocalContext requestedContext) {
    if (requestedContext != context || _stopped) return Future.value();
    final inFlight = _stopInFlight;
    if (inFlight != null) return inFlight;
    _stopping = true;
    _emit(SyncState(status: SyncStatus.stopping, completedPages: _state.completedPages));
    cancel();
    final stopping = _stopSafely();
    _stopInFlight = stopping.whenComplete(() => _stopInFlight = null);
    return _stopInFlight!;
  }

  Future<void> _stopSafely() async {
    final running = _activeRun;
    if (running != null) {
      try {
        await running.timeout(stopTimeout);
      } on TimeoutException {
        // Keep the context stopping. A caller must not close its database and
        // may retry stop after the in-flight operation reaches a safe point.
        throw const SyncStopTimeoutException();
      }
    }
    _stopped = true;
    _emit(const SyncState(status: SyncStatus.stopped));
    // A paused UI stream must not hold the database teardown hostage. Once
    // the run finished, no task retained by this engine can touch Drift.
    unawaited(_changes.close());
  }
}

class _CollectionResult {
  const _CollectionResult(this.pages, this.finished);
  final int pages;
  final bool finished;
}

class _HeartbeatWorker {
  _HeartbeatWorker({required this.interval, required this.onTick}) {
    done = _run();
  }

  final Duration interval;
  final Future<void> Function() onTick;
  final _stopSignal = Completer<void>();
  late final Future<void> done;

  void stop() {
    if (!_stopSignal.isCompleted) _stopSignal.complete();
  }

  Future<void> _run() async {
    while (!_stopSignal.isCompleted) {
      await Future.any<void>([
        Future<void>.delayed(interval),
        _stopSignal.future,
      ]);
      if (_stopSignal.isCompleted) return;
      await onTick();
    }
  }
}
