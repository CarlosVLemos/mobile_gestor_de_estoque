import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../core/database/drift_sync_checkpoint_store.dart';
import '../../core/sync/sync_collection.dart';

class DemoSeedPage implements SyncPage {
  const DemoSeedPage({required this.hasMore, required this.checkpoint});

  @override
  final bool hasMore;

  @override
  final SyncCheckpoint checkpoint;
}

class DemoSeedCollection implements SyncCollection {
  DemoSeedCollection({required AppDatabase database})
    : _database = database,
      _store = DriftSyncCheckpointStore(database);

  static const collectionName = 'demo_seed';
  final AppDatabase _database;
  final DriftSyncCheckpointStore _store;

  @override
  String get name => collectionName;

  @override
  Future<SyncCheckpoint> readCheckpoint() async {
    return _store.read(collectionName);
  }

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    if (checkpoint.checkpoint == 'seeded') {
      return DemoSeedPage(hasMore: false, checkpoint: checkpoint);
    }

    return const DemoSeedPage(
      hasMore: true,
      checkpoint: SyncCheckpoint(
        checkpoint: 'seeded',
        isBootstrapped: true,
        totalReceived: 4,
      ),
    );
  }

  @override
  Future<void> commitPage(SyncPage page) async {
    if (page.checkpoint.checkpoint != 'seeded') {
      return;
    }

    final now = DateTime.now();
    final monthStr =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
    final scopeKey = 'day:$monthStr:1';

    await _store.commitPage(
      collection: collectionName,
      checkpoint: page.checkpoint,
      writeData: () async {
        // 1. Seed Categories with valid UUIDs
        await _database.batch((batch) {
          batch.insertAll(
            _database.categoriesTable,
            [
              CategoriesTableCompanion.insert(
                id: '550e8400-e29b-41d4-a716-446655440000',
                name: 'Bebidas',
              ),
              CategoriesTableCompanion.insert(
                id: '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
                name: 'Alimentos',
              ),
              CategoriesTableCompanion.insert(
                id: '7c9e6679-7425-40de-944b-e07fc1f90ae7',
                name: 'Limpeza',
              ),
            ],
            mode: InsertMode.insertOrReplace,
          );
        });

        // 2. Seed Products with numeric string IDs
        await _database.batch((batch) {
          batch.insertAll(
            _database.productsTable,
            [
              ProductsTableCompanion.insert(
                id: '101',
                name: 'Café Especial 500g',
                sku: 'BEB-001',
                price: const Value(25.50),
                stockQuantity: 50,
                stockStatus: 'in_stock',
                isAvailableForSale: true,
                categoryId: const Value('550e8400-e29b-41d4-a716-446655440000'),
              ),
              ProductsTableCompanion.insert(
                id: '102',
                name: 'Suco Natural 1L',
                sku: 'BEB-002',
                price: const Value(12.00),
                stockQuantity: 30,
                stockStatus: 'in_stock',
                isAvailableForSale: true,
                categoryId: const Value('550e8400-e29b-41d4-a716-446655440000'),
              ),
              ProductsTableCompanion.insert(
                id: '103',
                name: 'Pão de Queijo Pacote',
                sku: 'ALI-001',
                price: const Value(18.90),
                stockQuantity: 20,
                stockStatus: 'in_stock',
                isAvailableForSale: true,
                categoryId: const Value('6ba7b810-9dad-11d1-80b4-00c04fd430c8'),
              ),
              ProductsTableCompanion.insert(
                id: '104',
                name: 'Detergente Neutro 500ml',
                sku: 'LIM-001',
                price: const Value(4.50),
                stockQuantity: 100,
                stockStatus: 'in_stock',
                isAvailableForSale: true,
                categoryId: const Value('7c9e6679-7425-40de-944b-e07fc1f90ae7'),
              ),
            ],
            mode: InsertMode.insertOrReplace,
          );
        });

        // 3. Seed Dashboard Snapshot for current scope
        final dashboardPayload = jsonEncode({
          'scope': scopeKey,
          'summary': {
            'sales_count': 12,
            'gross_total_cents': 154000,
            'net_total_cents': 148000,
            'restricted_financial': false,
          },
          'kpis': [
            {
              'key': 'gross_sales',
              'label': 'Vendas Brutas',
              'value': 'R\$ 1.540,00',
              'tone': 'positive',
            },
            {
              'key': 'orders_count',
              'label': 'Pedidos',
              'value': '12',
              'tone': 'neutral',
            },
          ],
          'alerts': [
            {
              'type': 'info',
              'message': 'Ambiente de demonstração local ativo.',
            },
          ],
          'recent_movements': [],
          'inventory_highlights': [],
          'goal': {
            'month': monthStr,
            'target_cents': 300000,
            'current_cents': 154000,
            'percentage': 51.3,
          },
        });

        await _database.into(_database.dashboardSnapshotsTable).insert(
              DashboardSnapshotsTableCompanion.insert(
                scopeKey: scopeKey,
                period: 'month',
                groupBy: 'day',
                page: 1,
                revision: 'demo-rev-1',
                generatedAt: now,
                referenceDate: now.toIso8601String(),
                webDashboardUrl: 'https://araragastos.local/dashboard',
                canViewFinancial: true,
                payloadJson: dashboardPayload,
              ),
              mode: InsertMode.insertOrReplace,
            );
      },
    );
  }
}
