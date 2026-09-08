import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_lifecycle_observer.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';
import 'package:gestor_de_estoque/core/sync/sync_lease.dart';
import 'package:gestor_de_estoque/core/sync/sync_state.dart';
import 'package:gestor_de_estoque/core/sync/sync_providers.dart';

class TestPage implements SyncPage {
  TestPage(this.checkpoint, {this.hasMore = false});

  @override
  final SyncCheckpoint checkpoint;
  @override
  final bool hasMore;
}

class TestCollection implements SyncCollection {
  TestCollection(this.name);

  @override
  final String name;
  SyncCheckpoint saved = const SyncCheckpoint();
  int fetches = 0;
  int commits = 0;
  bool failFetch = false;
  bool failCommit = false;
  Completer<void>? gate;
  void Function()? onCommit;

  @override
  Future<SyncCheckpoint> readCheckpoint() async => saved;

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    fetches++;
    final currentGate = gate;
    if (currentGate != null) await currentGate.future;
    if (failFetch) throw StateError('remote failure');
    return TestPage(
      SyncCheckpoint(cursor: 'page-$fetches'),
      hasMore: fetches == 1,
    );
  }

  @override
  Future<void> commitPage(SyncPage page) async {
    if (failCommit) throw StateError('database failure');
    saved = page.checkpoint;
    commits++;
    onCommit?.call();
  }
}

class TestLeaseStore implements SyncLeaseStore {
  bool busy = false;
  bool failAcquire = false;
  final lease = TestLease();

  @override
  Future<SyncLease?> tryAcquire() async {
    if (failAcquire) throw StateError('acquire failure');
    return busy ? null : lease;
  }
}

class TestLease implements SyncLease {
  int releases = 0;
  bool failRelease = false;
  bool lost = false;

  @override
  Future<void> protect(Future<void> Function() write) async {
    if (lost) throw const SyncLeaseLost();
    await write();
  }

  @override
  Future<void> release() async {
    releases++;
    if (failRelease) throw StateError('release failure');
  }
}

class TrackedEngine extends SyncEngine {
  TrackedEngine()
    : super(collections: [], lock: SyncLock(), leaseStore: TestLeaseStore());

  int subscriptions = 0;

  @override
  Stream<SyncState> get changes {
    final source = super.changes;
    return Stream<SyncState>.multi((controller) {
      subscriptions++;
      final subscription = source.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller.onCancel = () async {
        subscriptions--;
        await subscription.cancel();
      };
    });
  }
}

void main() {
  late SyncLock lock;
  late TestLeaseStore leases;
  late TestCollection collection;
  late SyncEngine engine;
  late DateTime now;

  setUp(() {
    lock = SyncLock();
    leases = TestLeaseStore();
    collection = TestCollection('products');
    now = DateTime.utc(2026, 9, 8);
    engine = SyncEngine(collections: [collection], lock: lock, leaseStore: leases, now: () => now);
  });

  tearDown(() => engine.dispose());

  test('executa páginas e coleções na ordem registrada', () async {
    final order = <String>[];
    final categories = TestCollection('categories')
      ..onCommit = () => order.add('categories');
    collection.onCommit = () => order.add('products');
    final ordered = SyncEngine(collections: [categories, collection], lock: lock, leaseStore: leases);
    try {
      expect(await ordered.sync(), SyncOutcome.succeeded);
      expect(order, ['categories', 'categories', 'products', 'products']);
      expect(ordered.state.completedPages, 4);
    } finally {
      await ordered.dispose();
    }
  });

  test('descarta concorrência inclusive entre engines com a mesma trava', () async {
    collection.gate = Completer<void>();
    final running = engine.sync();
    final other = SyncEngine(collections: [collection], lock: lock, leaseStore: leases);
    try {
      expect(await engine.sync(), SyncOutcome.busy);
      expect(await other.sync(), SyncOutcome.busy);
      collection.gate!.complete();
      expect(await running, SyncOutcome.succeeded);
      expect(collection.fetches, 2);
    } finally {
      await other.dispose();
    }
  });

  test('falha remota preserva última página e libera lock para nova tentativa', () async {
    collection.onCommit = () => collection.failFetch = true;
    expect(await engine.sync(), SyncOutcome.failed);
    expect(collection.saved.cursor, 'page-1');
    expect(engine.state.completedPages, 1);
    collection.failFetch = false;
    collection.onCommit = null;
    expect(await engine.sync(), SyncOutcome.succeeded);
  });

  test('falha de persistência não avança checkpoint nem executa próxima coleção', () async {
    collection.failCommit = true;
    final next = TestCollection('dashboard');
    final ordered = SyncEngine(collections: [collection, next], lock: lock, leaseStore: leases);
    try {
      expect(await ordered.sync(), SyncOutcome.failed);
      expect(collection.saved.isEmpty, isTrue);
      expect(next.fetches, 0);
      expect(lock.tryAcquire(), isTrue);
      lock.release();
    } finally {
      await ordered.dispose();
    }
  });

  test('cooldown após sucesso e falha; manual ignora o intervalo', () async {
    expect(await engine.sync(trigger: SyncTrigger.resumed), SyncOutcome.succeeded);
    now = now.add(const Duration(minutes: 5));
    expect(await engine.sync(trigger: SyncTrigger.resumed), SyncOutcome.throttled);
    now = now.add(const Duration(milliseconds: 1));
    collection.failFetch = true;
    expect(await engine.sync(trigger: SyncTrigger.resumed), SyncOutcome.failed);
    expect(await engine.sync(trigger: SyncTrigger.resumed), SyncOutcome.throttled);
    collection.failFetch = false;
    expect(await engine.sync(), SyncOutcome.succeeded);
  });

  test('cancelamento durante download impede commit e libera trava', () async {
    collection.gate = Completer<void>();
    final running = engine.sync();
    await Future<void>.delayed(Duration.zero);
    engine.cancel();
    collection.gate!.complete();
    expect(await running, SyncOutcome.cancelled);
    expect(collection.commits, 0);
    expect(lock.tryAcquire(), isTrue);
    lock.release();
  });

  test('observer ignora pausa e limita eventos resumed repetidos', () async {
    final observer = SyncLifecycleObserver(engine);
    observer.didChangeAppLifecycleState(AppLifecycleState.paused);
    expect(collection.fetches, 0);
    observer.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);
    expect(collection.fetches, 2);
    observer.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);
    expect(collection.fetches, 2);
  });

  test('lock persistido ocupado não altera estado nem aplica cooldown', () async {
    leases.busy = true;
    expect(await engine.sync(trigger: SyncTrigger.resumed), SyncOutcome.busy);
    expect(engine.state.status, SyncStatus.idle);
    expect(collection.fetches, 0);
    leases.busy = false;
    expect(await engine.sync(trigger: SyncTrigger.resumed), SyncOutcome.succeeded);
  });

  test('falhas na aquisição e liberação sempre liberam mutex local', () async {
    leases.failAcquire = true;
    expect(await engine.sync(), SyncOutcome.failed);
    expect(leases.lease.releases, 0);
    leases.failAcquire = false;
    leases.lease.failRelease = true;
    expect(await engine.sync(), SyncOutcome.failed);
    expect(engine.state.status, SyncStatus.failed);
    leases.lease.failRelease = false;
    expect(await engine.sync(), SyncOutcome.succeeded);
  });

  test('perda de posse durante download impede gravação', () async {
    collection.gate = Completer<void>();
    final running = engine.sync();
    await Future<void>.delayed(Duration.zero);
    leases.lease.lost = true;
    collection.gate!.complete();
    expect(await running, SyncOutcome.failed);
    expect(collection.commits, 0);
    expect(leases.lease.releases, 1);
  });

  test('dispose aguarda download e liberação antes de concluir', () async {
    collection.gate = Completer<void>();
    final running = engine.sync();
    await Future<void>.delayed(Duration.zero);
    var disposed = false;
    final disposal = engine.dispose().then((_) => disposed = true);
    await Future<void>.delayed(Duration.zero);
    expect(disposed, isFalse);
    collection.gate!.complete();
    expect(await running, SyncOutcome.cancelled);
    await disposal;
    expect(leases.lease.releases, 1);
    expect(collection.commits, 0);
    expect(await engine.sync(), SyncOutcome.cancelled);
  });


  test('provider publica estado e autoDispose cancela assinatura da engine', () async {
    final tracked = TrackedEngine();
    final container = ProviderContainer(overrides: [
      syncEngineProvider.overrideWithValue(tracked),
    ]);
    try {
      final subscription = container.listen(syncStateProvider, (_, _) {});
      final initial = await container.read(syncStateProvider.future);
      expect(initial.status, SyncStatus.idle);
      expect(tracked.subscriptions, 1);
      await tracked.sync();
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(syncStateProvider).asData!.value.status,
        SyncStatus.succeeded,
      );
      subscription.close();
      await container.pump();
      expect(tracked.subscriptions, 0);
    } finally {
      container.dispose();
      await tracked.dispose();
    }
  });

}
