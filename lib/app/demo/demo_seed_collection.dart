import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../core/database/drift_sync_checkpoint_store.dart';
import '../../core/sync/sync_collection.dart';

class DemoSeedCollection implements SyncCollection {
  DemoSeedCollection({required AppDatabase database})
    : _database = database,
      _store = DriftSyncCheckpointStore(database);

  static const collectionName = 'demo_seed_v6';
  static const _historicalSaleOneId = '550e8400-e29b-41d4-a716-446655440201';
  static const _historicalSaleTwoId = '550e8400-e29b-41d4-a716-446655440202';
  final AppDatabase _database;
  final DriftSyncCheckpointStore _store;

  @override
  String get name => collectionName;

  @override
  Future<SyncCheckpoint> readCheckpoint() => _store.read(name);

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    final now = DateTime.now();
    final month =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
    final marker = 'seeded:$month';
    return _DemoSeedPage(
      hasMore: false,
      shouldSeed: checkpoint.checkpoint != marker,
      month: month,
      checkpoint: SyncCheckpoint(
        mode: 'seed',
        checkpoint: marker,
        isBootstrapped: true,
        totalReceived: 17,
      ),
    );
  }

  @override
  Future<void> commitPage(SyncPage page) {
    if (page is! _DemoSeedPage) throw ArgumentError.value(page, 'page');
    return _store.commitPage(
      collection: name,
      checkpoint: page.checkpoint,
      writeData: () async {
        if (!page.shouldSeed) return;
        final now = DateTime.now();
        final month = page.month;
        final scopeKey = 'day:$month:1';
        await _database.batch((batch) {
          batch.insertAllOnConflictUpdate(_database.categoriesTable, [
            CategoriesTableCompanion.insert(
              id: '550e8400-e29b-41d4-a716-446655440000',
              name: 'Bebidas',
            ),
            CategoriesTableCompanion.insert(
              id: '550e8400-e29b-41d4-a716-446655440001',
              name: 'Alimentos',
            ),
          ]);
          batch.insertAllOnConflictUpdate(_database.productsTable, [
            ProductsTableCompanion.insert(
              id: '101',
              name: 'Café Especial 500g',
              sku: 'BEB-101',
              brand: const Value('Arara Café'),
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
              brand: const Value('Vale Verde'),
              price: const Value(12),
              stockQuantity: 30,
              stockStatus: 'available',
              isAvailableForSale: true,
              categoryId: const Value('550e8400-e29b-41d4-a716-446655440000'),
            ),
            ProductsTableCompanion.insert(
              id: '103',
              name: 'Chá Gelado 1L',
              sku: 'BEB-103',
              brand: const Value('Vale Verde'),
              price: const Value(9.90),
              stockQuantity: 4,
              stockStatus: 'low',
              isAvailableForSale: true,
              categoryId: const Value('550e8400-e29b-41d4-a716-446655440000'),
            ),
            ProductsTableCompanion.insert(
              id: '104',
              name: 'Biscoito Integral 200g',
              sku: 'ALI-104',
              brand: const Value('Sabor da Terra'),
              price: const Value(7.50),
              stockQuantity: 0,
              stockStatus: 'out',
              isAvailableForSale: false,
              categoryId: const Value('550e8400-e29b-41d4-a716-446655440001'),
            ),
            ProductsTableCompanion.insert(
              id: '105',
              name: 'Granola Artesanal 350g',
              sku: 'ALI-105',
              brand: const Value('Sabor da Terra'),
              price: const Value(18.90),
              stockQuantity: 18,
              stockStatus: 'available',
              isAvailableForSale: true,
              categoryId: const Value('550e8400-e29b-41d4-a716-446655440001'),
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
            ClientsTableCompanion.insert(
              id: '203',
              name: 'Empório do Bairro',
              city: const Value('Santos'),
              state: const Value('SP'),
            ),
          ]);
          batch.insertAll(_database.localSalesTable, [
            LocalSalesTableCompanion.insert(
              id: _historicalSaleOneId,
              clientRequestId: '550e8400-e29b-41d4-a716-446655440101',
              clientId: '201',
              clientName: 'Mercado Central',
              soldAt: now.subtract(const Duration(days: 2)),
              timezone: 'America/Sao_Paulo',
              createdAt: now.subtract(const Duration(days: 2)),
              updatedAt: now.subtract(const Duration(days: 2)),
            ),
            LocalSalesTableCompanion.insert(
              id: _historicalSaleTwoId,
              clientRequestId: '550e8400-e29b-41d4-a716-446655440102',
              clientId: '202',
              clientName: 'Padaria Estrela',
              soldAt: now.subtract(const Duration(days: 1)),
              timezone: 'America/Sao_Paulo',
              createdAt: now.subtract(const Duration(days: 1)),
              updatedAt: now.subtract(const Duration(days: 1)),
            ),
          ], mode: InsertMode.insertOrIgnore);
          batch.insertAll(_database.localSaleItemsTable, [
            LocalSaleItemsTableCompanion.insert(
              id: const Value(-101),
              saleId: _historicalSaleOneId,
              productId: '101',
              productName: 'Café Especial 500g',
              productSku: const Value('BEB-101'),
              quantity: 6,
              historicalUnitPrice: const Value(25.50),
            ),
            LocalSaleItemsTableCompanion.insert(
              id: const Value(-102),
              saleId: _historicalSaleTwoId,
              productId: '102',
              productName: 'Suco Natural 1L',
              productSku: const Value('BEB-102'),
              quantity: 4,
              historicalUnitPrice: const Value(12),
            ),
          ], mode: InsertMode.insertOrIgnore);
          batch.insertAll(_database.syncOutbox, [
            SyncOutboxCompanion.insert(
              id: _historicalSaleOneId,
              clientRequestId: const Value('550e8400-e29b-41d4-a716-446655440101'),
              operationType: const Value('demo_history'),
              localOperationId: const Value(_historicalSaleOneId),
              status: 'confirmed',
              remoteSaleId: const Value('demo-history-1'),
            ),
            SyncOutboxCompanion.insert(
              id: _historicalSaleTwoId,
              clientRequestId: const Value('550e8400-e29b-41d4-a716-446655440102'),
              operationType: const Value('demo_history'),
              localOperationId: const Value(_historicalSaleTwoId),
              status: 'confirmed',
              remoteSaleId: const Value('demo-history-2'),
            ),
          ], mode: InsertMode.insertOrIgnore);
          batch.insert(
            _database.dashboardSnapshotsTable,
            DashboardSnapshotsTableCompanion.insert(
              scopeKey: scopeKey,
              period: 'month',
              groupBy: 'day',
              page: 1,
              revision: 'demo-v6',
              generatedAt: now,
              referenceDate: now.toIso8601String(),
              webDashboardUrl: 'https://demo.invalid/dashboard',
              canViewFinancial: true,
              payloadJson: jsonEncode({
                'kpis': {
                  'sales_count_today': 3,
                  'sales_count_month': 12,
                  'clients_active': 3,
                  'sold_this_month_cents': 154000,
                },
                'low_stock_alert': const [
                  {
                    'product_name': 'Chá Gelado 1L',
                    'stock_label': '4 unidades em estoque',
                    'tone_label': 'Atenção',
                  },
                  {
                    'product_name': 'Biscoito Integral 200g',
                    'stock_label': '0 unidade disponível',
                    'tone_label': 'Crítico',
                  },
                ],
                'recent_movements': {
                  'data': [
                    {
                      'product_name': 'Café Especial 500g',
                      'movement_label': 'Saída para venda',
                      'quantity_label': '6 unidades',
                      'occurred_at': 'Há 2 horas',
                    },
                    {
                      'product_name': 'Granola Artesanal 350g',
                      'movement_label': 'Reposição recebida',
                      'quantity_label': '12 unidades',
                      'occurred_at': 'Ontem',
                    },
                  ],
                },
                'stock_level_chart': const [
                  {'category': 'Disponível', 'total_quantity': 3, 'tone_label': 'Estável'},
                  {'category': 'Baixo', 'total_quantity': 1, 'tone_label': 'Atenção'},
                  {'category': 'Ruptura', 'total_quantity': 1, 'tone_label': 'Crítico'},
                ],
                'operational_goal_chart': {
                  'configured': true,
                  'summary': {
                    'target_cents': 300000,
                    'actual_accumulated_cents': 154000,
                    'progress_percent': 51.33,
                  },
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
    required this.month,
    required this.checkpoint,
  });

  @override
  final bool hasMore;
  final bool shouldSeed;
  final String month;
  @override
  final SyncCheckpoint checkpoint;
}
