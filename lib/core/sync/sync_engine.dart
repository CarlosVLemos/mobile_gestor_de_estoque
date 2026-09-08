import 'dart:async';

import 'sync_collection.dart';
import 'sync_exception.dart';
import 'sync_lease.dart';
import 'sync_lock.dart';
import 'sync_state.dart';

/// Núcleo testável. A composição deve compartilhar o banco entre lease e coleções.
class SyncEngine {
  SyncEngine({
    required List<SyncCollection> collections,
    required SyncLock lock,
    required SyncLeaseStore leaseStore,
    DateTime Function()? now,
  }) : _collections = List.unmodifiable(collections),
       _lock = lock,
       _leaseStore = leaseStore,
       _now = now ?? DateTime.now {
    if (collections.map((collection) => collection.name).toSet().length !=
        collections.length) {
      throw ArgumentError('Coleções de sincronização devem ter nomes únicos.');
    }
  }

  static const resumeCooldown = Duration(minutes: 5);
  final List<SyncCollection> _collections;
  final SyncLock _lock;
  final SyncLeaseStore _leaseStore;
  final DateTime Function() _now;
  final _changes = StreamController<SyncState>.broadcast();
  SyncState _state = const SyncState();
  DateTime? _lastFinishedAt;
  bool _cancelled = false;
  bool _disposed = false;
  bool _running = false;
  bool _accessDenied = false;
  Completer<void>? _finished;

  SyncState get state => _state;
  Stream<SyncState> get changes => _changes.stream;

  void cancel() {
    if (_running) _cancelled = true;
  }

  void _emit(SyncState state) {
    _state = SyncState(
      status: state.status,
      collection: state.collection,
      completedPages: state.completedPages,
      failureKind: state.failureKind,
      completedCollections: state.completedCollections,
      accessDenied: _accessDenied,
    );
    if (!_disposed) _changes.add(_state);
  }

  Future<SyncOutcome> sync({SyncTrigger trigger = SyncTrigger.manual}) async {
    if (_disposed) return SyncOutcome.cancelled;
    if (_running) return SyncOutcome.busy;
    final lastFinished = _lastFinishedAt;
    if (trigger == SyncTrigger.resumed &&
        lastFinished != null &&
        _now().difference(lastFinished) <= resumeCooldown) {
      return SyncOutcome.throttled;
    }
    if (!_lock.tryAcquire()) return SyncOutcome.busy;
    _running = true;
    _cancelled = false;
    _finished = Completer<void>();
    SyncLease? lease;
    var outcome = SyncOutcome.failed;
    var attempted = false;
    SyncFailureKind? failureKind;
    var pages = 0;
    final completedCollections = <String>{};
    String? activeCollection;
    try {
      lease = await _leaseStore.tryAcquire();
      if (lease == null) return SyncOutcome.busy;
      attempted = true;
      _emit(const SyncState(status: SyncStatus.syncing));
      for (final collection in _collections) {
        if (_cancelled) break;
        activeCollection = collection.name;
        _emit(SyncState(
          status: SyncStatus.syncing,
          collection: activeCollection,
          completedPages: pages,
        ));
        var checkpoint = await collection.readCheckpoint();
        while (!_cancelled) {
          await lease.protect(() async {});
          if (_cancelled) break;
          final page = await collection.fetchPage(checkpoint);
          if (_cancelled) break;
          if (page.hasMore &&
              page.checkpoint.cursor == checkpoint.cursor &&
              page.checkpoint.lastSyncedAt == checkpoint.lastSyncedAt) {
            throw StateError('Página sem avanço de checkpoint.');
          }
          await lease.protect(() async {
            if (_cancelled) throw const _SyncCancelled();
            await collection.commitPage(page);
          });
          checkpoint = page.checkpoint;
          pages++;
          _emit(SyncState(
            status: SyncStatus.syncing,
            collection: activeCollection,
            completedPages: pages,
          ));
          if (!page.hasMore) break;
        }
        if (!_cancelled) completedCollections.add(collection.name);
      }
      outcome = _cancelled ? SyncOutcome.cancelled : SyncOutcome.succeeded;
    } catch (error) {
      // Exceções técnicas/payloads não devem alcançar o estado visual.
      attempted = true;
      failureKind = error is SyncException ? error.kind : SyncFailureKind.local;
      // Uma remontagem da tela não pode contornar 401/403. A sessão deve
      // revalidar o contexto e recompor a engine para liberar a leitura.
      if (failureKind == SyncFailureKind.unauthorized || failureKind == SyncFailureKind.forbidden) {
        _accessDenied = true;
      }
      outcome = _cancelled ? SyncOutcome.cancelled : SyncOutcome.failed;
    } finally {
      try {
        await lease?.release();
      } catch (_) {
        // Mesmo uma falha no banco ao liberar não pode reter o mutex local.
        // A lease persistida ficará recuperável pelo TTL.
        outcome = _cancelled ? SyncOutcome.cancelled : SyncOutcome.failed;
        failureKind = SyncFailureKind.local;
      } finally {
        _lock.release();
        _running = false;
        if (attempted) {
          _lastFinishedAt = _now();
          _emit(SyncState(
            status: switch (outcome) {
              SyncOutcome.succeeded => SyncStatus.succeeded,
              SyncOutcome.cancelled => SyncStatus.cancelled,
              _ => SyncStatus.failed,
            },
            collection: outcome == SyncOutcome.failed ? activeCollection : null,
            completedPages: pages,
            failureKind: failureKind,
            completedCollections: Set.unmodifiable(completedCollections),
          ));
        }
        _finished!.complete();
      }
    }
    return outcome;
  }

  /// Cancela entre páginas; uma transação em andamento pode terminar.
  /// Aguarda o sync e sua liberação antes de permitir fechar o banco.
  Future<void> dispose() async {
    cancel();
    _disposed = true;
    await _finished?.future;
    await _changes.close();
  }
}

class _SyncCancelled implements Exception {
  const _SyncCancelled();
}
