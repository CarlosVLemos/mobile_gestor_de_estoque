import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/data_purge_service.dart';
import 'package:gestor_de_estoque/core/database/database_factory.dart';
import 'package:gestor_de_estoque/core/database/local_context.dart';
import 'package:gestor_de_estoque/core/sync/context_sync_lifecycle.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_lease.dart';
import 'package:gestor_de_estoque/core/sync/sync_lifecycle.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';

void main() {
  test(
    'cada usuário e tenant usa um arquivo físico isolado e reutilizável',
    () async {
      final root = await Directory.systemTemp.createTemp('context-db-test');
      addTearDown(() => root.delete(recursive: true));
      final factory = _factory(root);
      const x = LocalContext(userId: 'user-x', tenantId: 'tenant-1');
      const y = LocalContext(userId: 'user-y', tenantId: 'tenant-2');

      final xPath = await factory.databasePathFor(x);
      final yPath = await factory.databasePathFor(y);
      expect(xPath, endsWith('app_database_u_user-x_t_tenant-1.db'));
      expect(yPath, isNot(xPath));

      final xDatabase = await factory.open(x);
      await xDatabase
          .into(xDatabase.syncOutbox)
          .insert(
            SyncOutboxCompanion.insert(id: 'sale-pending', status: 'pending'),
          );
      await xDatabase
          .into(xDatabase.productsTable)
          .insert(
            ProductsTableCompanion.insert(
              id: 'product-x',
              name: 'Produto X',
              sku: 'SKU-X',
              stockQuantity: 1,
              stockStatus: 'available',
              isAvailableForSale: true,
            ),
          );
      await xDatabase
          .into(xDatabase.clientsTable)
          .insert(ClientsTableCompanion.insert(id: '201', name: 'Cliente X'));
      await factory.closeActive();
      expect(File(xPath).existsSync(), isTrue);

      final yDatabase = await factory.open(y);
      expect(await yDatabase.pendingOutboxCount(), 0);
      expect(await yDatabase.activeProducts().get(), isEmpty);
      expect(await yDatabase.select(yDatabase.clientsTable).get(), isEmpty);
      await factory.closeActive();
      expect(File(yPath).existsSync(), isTrue);

      final restoredX = await factory.open(x);
      expect(await restoredX.pendingOutboxCount(), 1);
      expect(await restoredX.activeProducts().get(), hasLength(1));
      expect(
        await restoredX.select(restoredX.clientsTable).get(),
        hasLength(1),
      );
      await factory.closeActive();
    },
  );

  test(
    'purge fecha antes de limpar somente o cache do contexto e preserva outbox',
    () async {
      final root = await Directory.systemTemp.createTemp('context-purge-test');
      addTearDown(() => root.delete(recursive: true));
      final factory = _factory(root);
      const context = LocalContext(userId: 'user-x', tenantId: 'tenant-1');
      const anotherContext = LocalContext(
        userId: 'user-y',
        tenantId: 'tenant-2',
      );
      final database = await factory.open(context);
      await database
          .into(database.syncOutbox)
          .insert(
            SyncOutboxCompanion.insert(id: 'sale-pending', status: 'pending'),
          );
      final ownCache = Directory(
        '${root.path}${Platform.pathSeparator}arara_context_cache${Platform.pathSeparator}${context.cacheDirectoryName}',
      )..createSync(recursive: true);
      File(
        '${ownCache.path}${Platform.pathSeparator}image.tmp',
      ).writeAsStringSync('x');
      final otherCache = Directory(
        '${root.path}${Platform.pathSeparator}arara_context_cache${Platform.pathSeparator}${anotherContext.cacheDirectoryName}',
      )..createSync(recursive: true);
      final steps = <String>[];
      final service = DataPurgeService(
        factory,
        _RecordingSyncLifecycle(steps),
        ContextCacheCleaner(temporaryDirectory: () async => root),
        () => steps.add('invalidated'),
        (step) => steps.add(step.name),
      );

      expect(await service.pendingOutboxCount(), 1);
      await service.purge();

      expect(steps, [
        'sync-stopped',
        'syncStopped',
        'databaseClosed',
        'cacheCleared',
        'invalidated',
        'stateInvalidated',
      ]);
      expect(factory.activeDatabase, isNull);
      expect(ownCache.existsSync(), isFalse);
      expect(otherCache.existsSync(), isTrue);

      final restored = await factory.open(context);
      expect(await restored.pendingOutboxCount(), 1);
      await factory.closeActive();
    },
  );

  test(
    'purges concorrentes compartilham uma única sequência de teardown',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'context-purge-flight',
      );
      addTearDown(() => root.delete(recursive: true));
      final factory = _factory(root);
      const context = LocalContext(userId: 'user-x', tenantId: 'tenant-1');
      await factory.open(context);
      final steps = <PurgeStep>[];
      var invalidations = 0;
      final sync = _BlockingSyncLifecycle();
      final service = DataPurgeService(
        factory,
        sync,
        ContextCacheCleaner(temporaryDirectory: () async => root),
        () => invalidations += 1,
        steps.add,
      );

      final first = service.purge();
      final second = service.purge();
      final third = service.purge();
      await Future<void>.delayed(Duration.zero);
      expect(sync.calls, 1);

      sync.release();
      await Future.wait([first, second, third]);

      expect(
        steps.where((step) => step == PurgeStep.syncStopped),
        hasLength(1),
      );
      expect(
        steps.where((step) => step == PurgeStep.databaseClosed),
        hasLength(1),
      );
      expect(
        steps.where((step) => step == PurgeStep.cacheCleared),
        hasLength(1),
      );
      expect(
        steps.where((step) => step == PurgeStep.stateInvalidated),
        hasLength(1),
      );
      expect(invalidations, 1);
      expect(factory.activeDatabase, isNull);
      expect(factory.activeContext, isNull);
    },
  );

  test(
    'falha no stop preserva banco e contexto para retry recuperável',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'context-stop-failure',
      );
      addTearDown(() => root.delete(recursive: true));
      final factory = _factory(root);
      const context = LocalContext(userId: 'user-x', tenantId: 'tenant-1');
      await factory.open(context);
      final service = DataPurgeService(
        factory,
        _FailingSyncLifecycle(),
        ContextCacheCleaner(temporaryDirectory: () async => root),
        () {},
      );

      await expectLater(service.purge(), throwsStateError);
      expect(factory.activeDatabase, isNotNull);
      expect(factory.activeContext, context);
      await factory.closeActive();
    },
  );

  test(
    'purge waits for a registered engine before closing the active database',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'context-engine-purge',
      );
      addTearDown(() => root.delete(recursive: true));
      final factory = _factory(root);
      const context = LocalContext(userId: 'user-x', tenantId: 'tenant-1');
      await factory.open(context);
      final collection = _EngineCollection();
      final engine = SyncEngine(
        context: context,
        collections: [collection],
        lock: SyncLock(),
        leaseStore: _EngineLeaseStore(),
      );
      final lifecycle = ContextSyncLifecycle()..register(engine);
      final service = DataPurgeService(
        factory,
        lifecycle,
        ContextCacheCleaner(temporaryDirectory: () async => root),
        () {},
      );

      final running = engine.sync();
      await Future<void>.delayed(Duration.zero);
      final purging = service.purge();
      await Future<void>.delayed(Duration.zero);

      expect(collection.requestCancelled, isTrue);
      expect(factory.activeDatabase, isNotNull);
      collection.fetchGate.complete();

      await running;
      await purging;
      expect(engine.isStopped, isTrue);
      expect(factory.activeDatabase, isNull);
      expect(factory.activeContext, isNull);
    },
  );
}

DatabaseFactory _factory(Directory root) => DatabaseFactory(
  documentsDirectory: () async => root,
  temporaryDirectory: () async => root,
);

class _RecordingSyncLifecycle implements SyncLifecycle {
  _RecordingSyncLifecycle(this.steps);

  final List<String> steps;

  @override
  Future<void> stop(LocalContext context) async => steps.add('sync-stopped');
}

class _BlockingSyncLifecycle implements SyncLifecycle {
  final _release = Completer<void>();
  int calls = 0;

  @override
  Future<void> stop(LocalContext context) {
    calls += 1;
    return _release.future;
  }

  void release() => _release.complete();
}

class _FailingSyncLifecycle implements SyncLifecycle {
  @override
  Future<void> stop(LocalContext context) =>
      Future<void>.error(StateError('timeout'));
}

class _EngineCollection implements SyncCollection, CancellableSyncCollection {
  final fetchGate = Completer<void>();
  bool requestCancelled = false;

  @override
  String get name => 'products';

  @override
  Future<SyncCheckpoint> readCheckpoint() async => const SyncCheckpoint();

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    await fetchGate.future;
    return const _EnginePage();
  }

  @override
  Future<void> commitPage(SyncPage page) async {}

  @override
  void cancelPendingRequest() => requestCancelled = true;
}

class _EnginePage implements SyncPage {
  const _EnginePage();

  @override
  SyncCheckpoint get checkpoint => const SyncCheckpoint();

  @override
  bool get hasMore => false;
}

class _EngineLeaseStore implements SyncLeaseStore {
  final _EngineLease _lease = _EngineLease();

  @override
  Future<SyncLease?> tryAcquire() async => _lease;
}

class _EngineLease implements SyncLease {
  @override
  Future<void> renew() async {}

  @override
  Future<void> protect(Future<void> Function() write) => write();

  @override
  Future<void> release() async {}
}
