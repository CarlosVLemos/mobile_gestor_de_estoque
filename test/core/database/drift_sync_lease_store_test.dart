import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_lease_store.dart';
import 'package:gestor_de_estoque/core/sync/sync_exception.dart';

void main() {
  late AppDatabase database;
  late DateTime now;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    now = DateTime.utc(2026, 9, 9, 12);
  });

  tearDown(() => database.close());

  test('acquires, rejects a valid competing lock, and releases by owner', () async {
    final firstStore = DriftSyncLeaseStore(database: database, now: () => now);
    final secondStore = DriftSyncLeaseStore(database: database, now: () => now);
    final first = await firstStore.tryAcquire();
    expect(first, isNotNull);
    expect(await secondStore.tryAcquire(), isNull);
    await first!.release();
    expect(await secondStore.tryAcquire(), isNotNull);
  });

  test('independent SQLite connections compete for the same sync lock', () async {
    final directory = await Directory.systemTemp.createTemp('sync-lock-connections');
    final file = File('${directory.path}${Platform.pathSeparator}context.db');
    final firstDatabase = AppDatabase(NativeDatabase(file));
    final secondDatabase = AppDatabase(NativeDatabase(file));
    try {
      final firstStore = DriftSyncLeaseStore(database: firstDatabase, now: () => now);
      final secondStore = DriftSyncLeaseStore(database: secondDatabase, now: () => now);
      final first = await firstStore.tryAcquire();
      expect(first, isNotNull);
      expect(await secondStore.tryAcquire(), isNull);

      await first!.release();
      final second = await secondStore.tryAcquire();
      expect(second, isNotNull);
      await second!.release();
    } finally {
      await firstDatabase.close();
      await secondDatabase.close();
      await directory.delete(recursive: true);
    }
  });

  test('takes over only at expiry and old owner cannot renew or release', () async {
    final firstStore = DriftSyncLeaseStore(database: database, now: () => now);
    final first = await firstStore.tryAcquire();
    now = now.add(const Duration(minutes: 1, seconds: 59));
    final secondStore = DriftSyncLeaseStore(database: database, now: () => now);
    expect(await secondStore.tryAcquire(), isNull);

    now = now.add(const Duration(seconds: 1));
    final second = await secondStore.tryAcquire();
    expect(second, isNotNull);
    await expectLater(first!.renew(), throwsA(isA<SyncLeaseLost>()));
    await first.release();
    final rowsAfterOldRelease = await database.customSelect('SELECT * FROM sync_locks').get();
    expect(rowsAfterOldRelease, hasLength(1));
    await second!.release();
    expect(await database.customSelect('SELECT * FROM sync_locks').get(), isEmpty);
  });

  test('renew extends the UTC TTL only for its current owner', () async {
    final store = DriftSyncLeaseStore(database: database, now: () => now);
    final lease = await store.tryAcquire();
    now = now.add(const Duration(seconds: 30));
    await lease!.renew();
    final row = await database.customSelect('SELECT expires_at FROM sync_locks').getSingle();
    expect(row.read<int>('expires_at'), now.add(const Duration(minutes: 2)).millisecondsSinceEpoch);
  });
}
