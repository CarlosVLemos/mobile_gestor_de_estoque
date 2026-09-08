import 'dart:math';

import 'package:drift/drift.dart';

import '../sync/sync_lease.dart';
import 'app_database.dart';

/// Uma instância por executor, usando o banco do contexto autenticado.
class DriftSyncLeaseStore implements SyncLeaseStore {
  DriftSyncLeaseStore({
    required this.database,
    required this.ttl,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    if (ttl.inMilliseconds <= 0) {
      throw ArgumentError.value(ttl, 'ttl', 'Deve ser positivo em milissegundos.');
    }
  }

  final AppDatabase database;
  final Duration ttl;
  final DateTime Function() _now;
  static const _lockName = 'global_sync';

  @override
  Future<SyncLease?> tryAcquire() async {
    // Identidade nova a cada aquisição, inclusive no mesmo executor.
    final random = Random.secure();
    final owner = List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final now = _now().millisecondsSinceEpoch;
    final changed = await database.customUpdate(
      '''INSERT INTO sync_locks (name, owner_id, acquired_at, expires_at)
         VALUES (?, ?, ?, ?)
         ON CONFLICT(name) DO UPDATE SET
           owner_id = excluded.owner_id,
           acquired_at = excluded.acquired_at,
           expires_at = excluded.expires_at
         WHERE sync_locks.expires_at <= ?''',
      variables: [
        const Variable<String>(_lockName),
        Variable<String>(owner),
        Variable<int>(now),
        Variable<int>(now + ttl.inMilliseconds),
        Variable<int>(now),
      ],
      updates: {database.syncLocksTable},
    );
    return changed == 1 ? _DriftSyncLease(this, owner) : null;
  }
}

class _DriftSyncLease implements SyncLease {
  _DriftSyncLease(this.store, this.owner);

  final DriftSyncLeaseStore store;
  final String owner;

  Future<void> _renew() async {
    final now = store._now().millisecondsSinceEpoch;
    final changed = await store.database.customUpdate(
      '''UPDATE sync_locks SET expires_at = ?
         WHERE name = ? AND owner_id = ? AND expires_at > ?''',
      variables: [
        Variable<int>(now + store.ttl.inMilliseconds),
        const Variable<String>(DriftSyncLeaseStore._lockName),
        Variable<String>(owner),
        Variable<int>(now),
      ],
      updates: {store.database.syncLocksTable},
    );
    if (changed != 1) throw const SyncLeaseLost();
  }

  @override
  Future<void> protect(Future<void> Function() write) {
    return store.database.transaction(() async {
      // UPDATE é a primeira operação: adquire a trava de escrita SQLite antes
      // de validar a posse. Outro executor não pode assumir durante o commit.
      await _renew();
      await write();
      // Se a escrita excedeu o TTL, reverte a página e o checkpoint.
      await _renew();
    });
  }

  @override
  Future<void> release() async {
    await store.database.customUpdate(
      'DELETE FROM sync_locks WHERE name = ? AND owner_id = ?',
      variables: [
        const Variable<String>(DriftSyncLeaseStore._lockName),
        Variable<String>(owner),
      ],
      updates: {store.database.syncLocksTable},
    );
  }
}
