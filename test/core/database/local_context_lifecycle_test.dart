import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/data_purge_service.dart';
import 'package:gestor_de_estoque/core/database/database_factory.dart';
import 'package:gestor_de_estoque/core/database/local_context.dart';
import 'package:gestor_de_estoque/core/sync/sync_lifecycle.dart';

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
      await factory.closeActive();
      expect(File(xPath).existsSync(), isTrue);

      final yDatabase = await factory.open(y);
      expect(await yDatabase.pendingOutboxCount(), 0);
      await factory.closeActive();
      expect(File(yPath).existsSync(), isTrue);

      final restoredX = await factory.open(x);
      expect(await restoredX.pendingOutboxCount(), 1);
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
      final root = await Directory.systemTemp.createTemp('context-purge-flight');
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

      expect(steps.where((step) => step == PurgeStep.syncStopped), hasLength(1));
      expect(
        steps.where((step) => step == PurgeStep.databaseClosed),
        hasLength(1),
      );
      expect(steps.where((step) => step == PurgeStep.cacheCleared), hasLength(1));
      expect(
        steps.where((step) => step == PurgeStep.stateInvalidated),
        hasLength(1),
      );
      expect(invalidations, 1);
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
