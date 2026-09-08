import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/sync/read_sync_providers.dart';
import 'package:gestor_de_estoque/app/sync/read_sync_scope.dart';
import 'package:gestor_de_estoque/core/database/database_providers.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_lease.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';
import 'package:gestor_de_estoque/core/sync/sync_providers.dart';
import 'package:gestor_de_estoque/features/dashboard/dashboard_providers.dart';

class _Lease implements SyncLease, SyncLeaseStore {
  @override
  Future<SyncLease?> tryAcquire() async => this;
  @override
  Future<void> protect(Future<void> Function() write) => write();
  @override
  Future<void> release() async {}
}

class _Page implements SyncPage {
  @override
  bool get hasMore => false;
  @override
  SyncCheckpoint get checkpoint => const SyncCheckpoint();
}

class _Collection implements SyncCollection {
  int fetches = 0;
  @override
  String get name => 'test';
  @override
  Future<SyncCheckpoint> readCheckpoint() async => const SyncCheckpoint();
  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    fetches++;
    return _Page();
  }
  @override
  Future<void> commitPage(SyncPage page) async {}
}

void main() {
  test('composição padrão não abre banco nem cria engine/decoder anônimos', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(operationalDatabaseProvider), isNull);
    expect(container.read(readSyncEngineProvider), isNull);
    expect(container.read(dashboardRemoteDecoderProvider), isNull);
  });

  testWidgets('binding inicia bootstrap e remove observer no descarte', (tester) async {
    var now = DateTime.utc(2026, 9, 8);
    final collection = _Collection();
    final engine = SyncEngine(collections: [collection], lock: SyncLock(), leaseStore: _Lease(), now: () => now);
    await tester.pumpWidget(ProviderScope(
      overrides: [syncEngineProvider.overrideWithValue(engine)],
      child: const ReadSyncScope(child: SizedBox()),
    ));
    await tester.pumpAndSettle();
    expect(collection.fetches, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    now = now.add(const Duration(minutes: 6));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(collection.fetches, 1);
    await engine.dispose();
  });
}
