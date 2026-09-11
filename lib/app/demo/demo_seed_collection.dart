import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../core/database/drift_sync_checkpoint_store.dart';
import '../../core/sync/sync_collection.dart';

class DemoSeedCollection implements SyncCollection {
  DemoSeedCollection({required AppDatabase database})
    : _database = database,
      _store = DriftSyncCheckpointStore(database);

  static const collectionName = 'demo_seed_v5';
  final AppDatabase _database;
  final DriftSyncCheckpointStore _store;

  @override
  String get name => collectionName;

  @override
  Future<SyncCheckpoint> readCheckpoint() => _store.read(name);

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async => _DemoSeedPage(
    hasMore: false,
    shouldSeed: checkpoint.checkpoint != 'seeded',
    checkpoint: const SyncCheckpoint(
      mode: 'seed',
      checkpoint: 'seeded',
      isBootstrapped: true,
      totalReceived: 7,
    ),
  );

  @override
  Future<void> commitPage(SyncPage page) {
    if (page is! _DemoSeedPage) throw ArgumentError.value(page, 'page');
    return _store.commitPage(
      collection: name,
      checkpoint: page.checkpoint,
      writeData: () async {
        if (!page.shouldSeed) return;
        final now = DateTime.now();
        final month =
            '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
        final scopeKey = 'day:$month:1';
        await _database.batch((batch) {
          batch.insertAllOnConflictUpdate(_database.categoriesTable, [
            CategoriesTableCompanion.insert(
              id: '550e8400-e29b-41d4-a716-446655440000',
              name: 'Bebidas',
            ),
          ]);
          batch.insertAllOnConflictUpdate(_database.productsTable, [
            ProductsTableCompanion.insert(
              id: '101',
              name: 'Café Especial 500g',
              sku: 'BEB-101',
              price: const Value(25.50),
              stockQuantity: 50,
              stockStatus: 'available',
              isAvailableForSale: true,
              categoryId: const Value('550e8400-e29b-41d4-a716-446655440000'),
            ),
            ProductsTableCompanion.insert(
              id: '102',
              name: 'Suco Natural 1L',
              sku: 'BEB-102',
              price: const Value(12),
              stockQuantity: 30,
              stockStatus: 'available',
              isAvailableForSale: true,
              categoryId: const Value('550e8400-e29b-41d4-a716-446655440000'),
            ),
          ]);
          batch.insertAllOnConflictUpdate(_database.clientsTable, [
            ClientsTableCompanion.insert(
              id: '201',
              name: 'Mercado Central',
              city: const Value('São Paulo'),
              state: const Value('SP'),
            ),
            ClientsTableCompanion.insert(
              id: '202',
              name: 'Padaria Estrela',
              city: const Value('Campinas'),
              state: const Value('SP'),
            ),
          ]);
          batch.insert(
            _database.dashboardSnapshotsTable,
            DashboardSnapshotsTableCompanion.insert(
              scopeKey: scopeKey,
              period: 'month',
              groupBy: 'day',
              page: 1,
              revision: 'demo-v5',
              generatedAt: now,
              referenceDate: now.toIso8601String(),
              webDashboardUrl: 'https://demo.invalid/dashboard',
              canViewFinancial: true,
              payloadJson: jsonEncode({
                'scope': scopeKey,
                'summary': {
                  'sales_count': 12,
                  'gross_total_cents': 154000,
                  'net_total_cents': 148000,
                  'restricted_financial': false,
                },
                'kpis': const [],
                'alerts': const [],
                'recent_movements': const [],
                'inventory_highlights': const [],
                'goal': {
                  'month': month,
                  'target_cents': 300000,
                  'current_cents': 154000,
                  'percentage': 51.3,
                },
              }),
            ),
            mode: InsertMode.insertOrReplace,
          );
        });
      },
    );
  }
}

class _DemoSeedPage implements SyncPage {
  const _DemoSeedPage({
    required this.hasMore,
    required this.shouldSeed,
    required this.checkpoint,
  });

  @override
  final bool hasMore;
  final bool shouldSeed;
  @override
  final SyncCheckpoint checkpoint;
}
