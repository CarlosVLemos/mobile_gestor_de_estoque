import 'dart:math';

import 'package:drift/drift.dart';

import '../sync/sync_exception.dart';
import '../sync/sync_lease.dart';
import 'app_database.dart';

/// Persistent, contextual lease. SQLite makes acquisition/takeover atomic.
class DriftSyncLeaseStore implements SyncLeaseStore {
  DriftSyncLeaseStore({
    required this.database,
    DateTime Function()? now,
    Random? random,
  }) : _now = now ?? DateTime.now,
       _random = random ?? Random.secure();

  static const lockName = 'global_sync';
  static const ttl = Duration(minutes: 2);

  final AppDatabase database;
  final DateTime Function() _now;
  final Random _random;

  @override
  Future<SyncLease?> tryAcquire() async {
    final owner = List<String>.generate(
      24,
      (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final instant = _now().toUtc().millisecondsSinceEpoch;
    final changed = await database.customUpdate(
      '''INSERT INTO sync_locks (name, owner_id, acquired_at, expires_at)
         VALUES (?, ?, ?, ?)
         ON CONFLICT(name) DO UPDATE SET
           owner_id = excluded.owner_id,
           acquired_at = excluded.acquired_at,
           expires_at = excluded.expires_at
         WHERE sync_locks.expires_at <= ?''',
      variables: [
        const Variable<String>(lockName),
        Variable<String>(owner),
        Variable<int>(instant),
        Variable<int>(instant + ttl.inMilliseconds),
        Variable<int>(instant),
      ],
      updates: {database.syncLocksTable},
    );
    return changed == 1 ? _DriftSyncLease(this, owner) : null;
  }
}

class _DriftSyncLease implements SyncLease {
  _DriftSyncLease(this._store, this._owner);

  final DriftSyncLeaseStore _store;
  final String _owner;

  @override
  Future<void> renew() async {
    final instant = _store._now().toUtc().millisecondsSinceEpoch;
    final changed = await _store.database.customUpdate(
      '''UPDATE sync_locks SET expires_at = ?
         WHERE name = ? AND owner_id = ? AND expires_at > ?''',
      variables: [
        Variable<int>(instant + DriftSyncLeaseStore.ttl.inMilliseconds),
        const Variable<String>(DriftSyncLeaseStore.lockName),
        Variable<String>(_owner),
        Variable<int>(instant),
      ],
      updates: {_store.database.syncLocksTable},
    );
    if (changed != 1) throw const SyncLeaseLost();
  }

  @override
  Future<void> protect(Future<void> Function() write) {
    return _store.database.transaction(() async {
      // The validation is first, so SQLite obtains its write lock before a
      // page/checkpoint can be committed. The final validation rolls both
      // changes back if ownership expired while the transaction was running.
      await renew();
      await write();
      await renew();
    });
  }

  @override
  Future<void> release() => _store.database.customUpdate(
    'DELETE FROM sync_locks WHERE name = ? AND owner_id = ?',
    variables: [
      const Variable<String>(DriftSyncLeaseStore.lockName),
      Variable<String>(_owner),
    ],
    updates: {_store.database.syncLocksTable},
  );
}
