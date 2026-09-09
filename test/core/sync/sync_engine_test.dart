import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/local_context.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_exception.dart';
import 'package:gestor_de_estoque/core/sync/sync_lease.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';
import 'package:gestor_de_estoque/core/sync/sync_state.dart';

class _Page implements SyncPage {
  const _Page(this.checkpoint);
  @override
  final SyncCheckpoint checkpoint;
  @override
  bool get hasMore => false;
}

class _Collection implements SyncCollection, CancellableSyncCollection {
  _Collection(this.name);
  @override
  final String name;
  SyncCheckpoint saved = const SyncCheckpoint();
  int commits = 0;
  bool failCommit = false;
  bool requestCancelled = false;
  Completer<void>? fetchGate;

  @override
  Future<SyncCheckpoint> readCheckpoint() async => saved;

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    await fetchGate?.future;
    return const _Page(SyncCheckpoint(cursor: 'opaque-next', isBootstrapped: true));
  }

  @override
  Future<void> commitPage(SyncPage page) async {
    if (failCommit) throw StateError('write failed');
    saved = page.checkpoint;
    commits++;
  }

  @override
  void cancelPendingRequest() => requestCancelled = true;
}

class _LeaseStore implements SyncLeaseStore {
  _LeaseStore(this.lease);
  final _Lease lease;
  bool busy = false;
  @override
  Future<SyncLease?> tryAcquire() async => busy ? null : lease;
}

class _Lease implements SyncLease {
  int renewals = 0;
  int releases = 0;
  bool lost = false;
  bool failRelease = false;
  int? blockRenewalNumber;
  Completer<void>? renewGate;
  Completer<void>? renewalBlocked;

  void _check() {
    if (lost) throw const SyncLeaseLost();
  }

  @override
  Future<void> renew() async {
    renewals++;
    if (renewals == blockRenewalNumber) {
      renewalBlocked?.complete();
      await renewGate?.future;
    }
    _check();
  }

  @override
  Future<void> protect(Future<void> Function() write) async {
    _check();
    await write();
    _check();
  }

  @override
  Future<void> release() async {
    releases++;
    if (failRelease) throw StateError('release failed');
  }
}

void main() {
  const context = LocalContext(userId: 'u', tenantId: 't');
  late _Collection collection;
  late _Lease lease;
  late SyncLock lock;
  late SyncEngine engine;

  setUp(() {
    collection = _Collection('products');
    lease = _Lease();
    lock = SyncLock();
    engine = SyncEngine(
      context: context,
      collections: [collection],
      lock: lock,
      leaseStore: _LeaseStore(lease),
    );
  });

  test('mutex shared blocks a second run and finally releases it', () async {
    collection.fetchGate = Completer<void>();
    final running = engine.sync();
    final second = SyncEngine(
      context: context,
      collections: [collection],
      lock: lock,
      leaseStore: _LeaseStore(lease),
    );
    expect(await second.sync(), SyncOutcome.busy);
    collection.fetchGate!.complete();
    expect(await running, SyncOutcome.succeeded);
    expect(lease.releases, 1);
    expect(await second.sync(), SyncOutcome.succeeded);
  });

  test('commit failure keeps the last safe checkpoint and releases lease', () async {
    collection.failCommit = true;
    expect(await engine.sync(), SyncOutcome.failed);
    expect(collection.saved.cursor, isNull);
    expect(lease.releases, 1);
  });

  test('cancellation while fetching prevents commit and releases lease', () async {
    collection.fetchGate = Completer<void>();
    final running = engine.sync();
    await Future<void>.delayed(Duration.zero);
    engine.cancel();
    collection.fetchGate!.complete();
    expect(await running, SyncOutcome.cancelled);
    expect(collection.commits, 0);
    expect(collection.requestCancelled, isTrue);
    expect(lease.releases, 1);
  });

  test('lost ownership after fetch aborts before local page persistence', () async {
    collection.fetchGate = Completer<void>();
    final running = engine.sync();
    await Future<void>.delayed(Duration.zero);
    lease.lost = true;
    collection.fetchGate!.complete();
    expect(await running, SyncOutcome.failed);
    expect(collection.commits, 0);
    expect(engine.state.failureKind, SyncFailureKind.ownershipLost);
  });

  test('heartbeat renews while a fetch is pending', () async {
    collection.fetchGate = Completer<void>();
    engine = SyncEngine(
      context: context,
      collections: [collection],
      lock: lock,
      leaseStore: _LeaseStore(lease),
      heartbeatInterval: const Duration(milliseconds: 1),
    );
    final running = engine.sync();
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(lease.renewals, greaterThan(1));
    collection.fetchGate!.complete();
    expect(await running, SyncOutcome.succeeded);
  });

  test('persistent lease busy does not emit failure or throttle resume', () async {
    final store = _LeaseStore(lease)..busy = true;
    engine = SyncEngine(
      context: context,
      collections: [collection],
      lock: lock,
      leaseStore: store,
    );

    expect(await engine.sync(), SyncOutcome.busy);
    expect(engine.state.status, SyncStatus.idle);

    store.busy = false;
    expect(await engine.sync(trigger: SyncTrigger.resumed), SyncOutcome.succeeded);
  });

  test('stop waits for an in-flight heartbeat before releasing lease', () async {
    collection.fetchGate = Completer<void>();
    lease
      ..blockRenewalNumber = 2
      ..renewGate = Completer<void>()
      ..renewalBlocked = Completer<void>();
    engine = SyncEngine(
      context: context,
      collections: [collection],
      lock: lock,
      leaseStore: _LeaseStore(lease),
      heartbeatInterval: const Duration(milliseconds: 1),
      stopTimeout: const Duration(milliseconds: 5),
    );

    final running = engine.sync();
    await lease.renewalBlocked!.future;
    final stopping = engine.stop(context);
    collection.fetchGate!.complete();

    await expectLater(stopping, throwsA(isA<SyncStopTimeoutException>()));
    expect(lease.releases, 0);
    expect(engine.isStopping, isTrue);

    lease.renewGate!.complete();
    expect(await running, SyncOutcome.cancelled);
    await engine.stop(context);
    expect(lease.releases, 1);
    expect(engine.isStopped, isTrue);
  });

  test('stop blocks new runs, cancels active work, and waits for safe point', () async {
    collection.fetchGate = Completer<void>();
    final running = engine.sync();
    await Future<void>.delayed(Duration.zero);
    final stopping = engine.stop(context);
    expect(await engine.sync(), SyncOutcome.stopped);
    collection.fetchGate!.complete();
    expect(await running, SyncOutcome.cancelled);
    await stopping;
    expect(engine.isStopped, isTrue);
  });

  test('stop timeout keeps the context stopping for a recoverable retry', () async {
    collection.fetchGate = Completer<void>();
    engine = SyncEngine(
      context: context,
      collections: [collection],
      lock: lock,
      leaseStore: _LeaseStore(lease),
      stopTimeout: const Duration(milliseconds: 1),
    );
    final running = engine.sync();
    await Future<void>.delayed(Duration.zero);
    await expectLater(engine.stop(context), throwsA(isA<SyncStopTimeoutException>()));
    expect(engine.isStopping, isTrue);
    expect(engine.isStopped, isFalse);
    collection.fetchGate!.complete();
    await running;
    await engine.stop(context);
    expect(engine.isStopped, isTrue);
  });
}
