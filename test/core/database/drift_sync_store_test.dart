import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_checkpoint_store.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_lease_store.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_lease.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';
import 'package:gestor_de_estoque/core/sync/sync_state.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

class _Page implements SyncPage {
  @override
  bool get hasMore => false;

  @override
  SyncCheckpoint get checkpoint => const SyncCheckpoint(cursor: 'page-1');
}

class _Collection implements SyncCollection {
  _Collection(this.store, this.writeData);

  final DriftSyncCheckpointStore store;
  final Future<void> Function() writeData;
  final fetching = Completer<void>();
  final download = Completer<void>();

  @override
  String get name => 'products';

  @override
  Future<SyncCheckpoint> readCheckpoint() => store.read(name);

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    fetching.complete();
    await download.future;
    return _Page();
  }

  @override
  Future<void> commitPage(SyncPage page) => store.commitPage(
    collection: name,
    checkpoint: page.checkpoint,
    writeData: writeData,
  );
}

void main() {
  late AppDatabase database;
  late DriftSyncLeaseStore leases;
  late DriftSyncCheckpointStore checkpoints;
  late DateTime now;
  const ttl = Duration(seconds: 30);

  setUp(() {
    now = DateTime.utc(2026, 9, 8);
    database = AppDatabase(NativeDatabase.memory());
    leases = DriftSyncLeaseStore(database: database, ttl: ttl, now: () => now);
    checkpoints = DriftSyncCheckpointStore(database);
  });

  tearDown(() => database.close());

  Future<void> writeCategory() async {
    await database.into(database.categoriesTable).insertOnConflictUpdate(
      CategoriesTableCompanion.insert(id: 'category-1', name: 'Peças'),
    );
  }

  Future<void> writePage(SyncLease lease, String cursor) => lease.protect(
    () => checkpoints.commitPage(
      collection: 'products',
      checkpoint: SyncCheckpoint(cursor: cursor),
      writeData: writeCategory,
    ),
  );

  test('engine usa lock persistido e rejeita página após perder a posse', () async {
    final collection = _Collection(checkpoints, writeCategory);
    final first = SyncEngine(
      collections: [collection],
      lock: SyncLock(),
      leaseStore: leases,
      now: () => now,
    );
    final second = SyncEngine(
      collections: [],
      lock: SyncLock(),
      leaseStore: DriftSyncLeaseStore(database: database, ttl: ttl, now: () => now),
      now: () => now,
    );
    try {
      final running = first.sync();
      await collection.fetching.future;
      expect(await second.sync(), SyncOutcome.busy);
      now = now.add(ttl);
      expect(await second.sync(), SyncOutcome.succeeded);
      collection.download.complete();
      expect(await running, SyncOutcome.failed);
      expect(first.state.completedPages, 0);
      expect((await checkpoints.read('products')).isEmpty, isTrue);
      expect(await database.select(database.categoriesTable).get(), isEmpty);
    } finally {
      if (!collection.download.isCompleted) collection.download.complete();
      await first.dispose();
      await second.dispose();
    }
  });

  test('aquisição única, renovação e liberação idempotente', () async {
    final lease = (await leases.tryAcquire())!;
    expect(await leases.tryAcquire(), isNull);
    final initial = await database.select(database.syncLocksTable).getSingle();
    expect(initial.acquiredAt, now.millisecondsSinceEpoch);
    now = now.add(const Duration(seconds: 20));
    await lease.protect(() async {});
    now = now.add(const Duration(seconds: 20));
    expect(await leases.tryAcquire(), isNull);
    await lease.release();
    await lease.release();
    expect(await database.select(database.syncLocksTable).get(), isEmpty);
    final next = (await leases.tryAcquire())!;
    await next.release();
  });

  test('TTL recupera abandono e executor antigo não escreve nem libera sucessor', () async {
    final old = (await leases.tryAcquire())!;
    final first = await database.select(database.syncLocksTable).getSingle();
    now = now.add(ttl);
    final next = (await leases.tryAcquire())!;
    final second = await database.select(database.syncLocksTable).getSingle();
    expect(second.ownerId, isNot(first.ownerId));
    await expectLater(writePage(old, 'stale'), throwsA(isA<SyncLeaseLost>()));
    expect(await database.select(database.categoriesTable).get(), isEmpty);
    expect((await checkpoints.read('products')).isEmpty, isTrue);
    await old.release();
    expect(await leases.tryAcquire(), isNull);
    await writePage(next, 'current');
    expect((await checkpoints.read('products')).cursor, 'current');
    await next.release();
  });

  test('expiração sem sucessor também bloqueia escrita', () async {
    final lease = (await leases.tryAcquire())!;
    now = now.add(ttl);
    await expectLater(writePage(lease, 'expired'), throwsA(isA<SyncLeaseLost>()));
    expect((await checkpoints.read('products')).isEmpty, isTrue);
    await lease.release();
  });

  test('expiração durante transação reverte dados e checkpoint', () async {
    final lease = (await leases.tryAcquire())!;
    await expectLater(
      lease.protect(() async {
        await checkpoints.commitPage(
          collection: 'products',
          checkpoint: const SyncCheckpoint(cursor: 'expired'),
          writeData: writeCategory,
        );
        now = now.add(ttl);
      }),
      throwsA(isA<SyncLeaseLost>()),
    );
    expect(await database.select(database.categoriesTable).get(), isEmpty);
    expect((await checkpoints.read('products')).isEmpty, isTrue);
    await lease.release();
  });

  test('upsert de página é idempotente e checkpoint pertence à coleção', () async {
    final lease = (await leases.tryAcquire())!;
    await writePage(lease, 'page-1');
    await writePage(lease, 'page-1');
    expect(await database.select(database.categoriesTable).get(), hasLength(1));
    expect((await checkpoints.read('products')).cursor, 'page-1');
    expect((await checkpoints.read('dashboard')).isEmpty, isTrue);
    await lease.release();
  });

  test('falha ao gravar checkpoint reverte dados e preserva página anterior', () async {
    final lease = (await leases.tryAcquire())!;
    await writePage(lease, 'page-1');
    await database.customStatement('''
      CREATE TRIGGER reject_checkpoint BEFORE UPDATE ON sync_checkpoints
      BEGIN SELECT RAISE(ABORT, 'checkpoint failure'); END
    ''');
    await expectLater(
      lease.protect(() => checkpoints.commitPage(
        collection: 'products',
        checkpoint: const SyncCheckpoint(cursor: 'page-2'),
        writeData: () async {
          await database.into(database.categoriesTable).insertOnConflictUpdate(
            CategoriesTableCompanion.insert(id: 'category-1', name: 'Alterado'),
          );
        },
      )),
      throwsA(isA<SqliteException>()),
    );
    expect((await checkpoints.read('products')).cursor, 'page-1');
    expect(
      (await database.select(database.categoriesTable).getSingle()).name,
      'Peças',
    );
    await lease.release();
  });

  test('falha de dados não avança checkpoint', () async {
    final lease = (await leases.tryAcquire())!;
    await writePage(lease, 'page-1');
    await expectLater(
      lease.protect(() => checkpoints.commitPage(
        collection: 'products',
        checkpoint: const SyncCheckpoint(cursor: 'page-2'),
        writeData: () async {
          await database.delete(database.categoriesTable).go();
          throw StateError('data failure');
        },
      )),
      throwsStateError,
    );
    expect((await checkpoints.read('products')).cursor, 'page-1');
    expect(await database.select(database.categoriesTable).get(), hasLength(1));
    await lease.release();
  });

  test('dois executores do mesmo arquivo disputam um único lock', () async {
    final directory = await Directory.systemTemp.createTemp('arara-sync-lock-');
    final file = File('${directory.path}/sync.sqlite');
    final first = AppDatabase(NativeDatabase(file));
    final second = AppDatabase(NativeDatabase(file));
    try {
      // Abrir sequencialmente para isolar a disputa do lock da criação do schema.
      await first.customSelect('SELECT 1').get();
      await second.customSelect('SELECT 1').get();
      final a = DriftSyncLeaseStore(database: first, ttl: ttl, now: () => now);
      final b = DriftSyncLeaseStore(database: second, ttl: ttl, now: () => now);
      final results = await Future.wait([a.tryAcquire(), b.tryAcquire()]);
      expect(results.whereType<SyncLease>(), hasLength(1));
      final winner = results.whereType<SyncLease>().single;
      await winner.release();
      final next = (await b.tryAcquire())!;
      await next.release();
    } finally {
      await first.close();
      await second.close();
      await directory.delete(recursive: true);
    }
  });

  test('reabertura preserva lock até expirar', () async {
    final directory = await Directory.systemTemp.createTemp('arara-sync-reopen-');
    final file = File('${directory.path}/sync.sqlite');
    try {
      final first = AppDatabase(NativeDatabase(file));
      try {
        final store = DriftSyncLeaseStore(database: first, ttl: ttl, now: () => now);
        expect(await store.tryAcquire(), isNotNull);
      } finally {
        await first.close();
      }
      final reopened = AppDatabase(NativeDatabase(file));
      try {
        final store = DriftSyncLeaseStore(database: reopened, ttl: ttl, now: () => now);
        expect(await store.tryAcquire(), isNull);
        now = now.add(ttl);
        final recovered = (await store.tryAcquire())!;
        await recovered.release();
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
