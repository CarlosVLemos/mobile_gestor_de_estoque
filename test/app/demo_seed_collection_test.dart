import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/demo/demo_seed_collection.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_checkpoint_store.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/features/dashboard/data/repositories/drift_dashboard_repository.dart';
import 'package:gestor_de_estoque/features/sales/data/repositories/drift_sales_repository.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';

void main() {
  test(
    'seed demo v6 atualiza painel e catálogo sem repetir no mesmo mês',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final collection = DemoSeedCollection(database: database);
      await DriftSyncCheckpointStore(database).commitPage(
        collection: 'demo_seed_v5',
        checkpoint: const SyncCheckpoint(checkpoint: 'seeded'),
        writeData: () async {},
      );

      await collection.commitPage(
        await collection.fetchPage(const SyncCheckpoint()),
      );
      await database.customUpdate(
        'UPDATE products SET stock_quantity = 49 WHERE id = ?',
        variables: const [Variable('101')],
        updates: {database.productsTable},
      );
      await collection.commitPage(
        await collection.fetchPage(await collection.readCheckpoint()),
      );
      expect(
        (await (database.select(database.productsTable)
              ..where((product) => product.id.equals('101'))).getSingle())
            .stockQuantity,
        49,
      );

      expect(
        (await database.select(database.productsTable).get()).map((e) => e.id),
        containsAll(['101', '102', '103', '104', '105']),
      );
      expect(
        (await database.select(database.clientsTable).get()).map((e) => e.id),
        containsAll(['201', '202', '203']),
      );
      expect(
        await database.select(database.categoriesTable).get(),
        hasLength(2),
      );
      expect(await database.select(database.clientsTable).get(), hasLength(3));
      final month = DateTime.now();
      final monthKey =
          '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';
      expect((await collection.readCheckpoint()).checkpoint, 'seeded:$monthKey');
      expect(
        (await DriftSyncCheckpointStore(database).read('demo_seed_v5'))
            .checkpoint,
        'seeded',
      );
      final dashboard = await DriftDashboardRepository(
        database,
        'day:$monthKey:1',
        canViewFinancialMetrics: true,
        syncCollectionName: DemoSeedCollection.collectionName,
      ).load();
      final overview = dashboard.overview!;
      expect(
        overview.syncedAt,
        (await database.readSyncCollection(DemoSeedCollection.collectionName))!
            .lastSuccessAt!
            .toLocal(),
      );
      expect(overview.kpis, hasLength(4));
      expect(overview.lowStockAlerts, hasLength(2));
      expect(overview.recentMovements, hasLength(2));
      expect(overview.stockLevelChart, hasLength(3));
      expect(overview.operationalGoalChart.progress, closeTo(0.5133, 0.0001));
      expect(overview.lowStockAlerts.first.productName, 'Chá Gelado 1L');
      final history = await DriftSalesRepository(database).watchSalesSummary().first;
      expect(history, hasLength(2));
      expect(history.map((sale) => sale.status),
          everyElement(SaleSyncStatus.confirmed));
      expect(history.map((sale) => sale.clientName),
          containsAll(['Mercado Central', 'Padaria Estrela']));
    },
  );

  test('nova versão do seed preserva uma venda local pendente', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final collection = DemoSeedCollection(database: database);
    await collection.commitPage(
      await collection.fetchPage(const SyncCheckpoint()),
    );
    final now = DateTime.now();
    const localSaleId = '550e8400-e29b-41d4-a716-446655440301';
    await DriftSalesRepository(database).register(
      localSaleId: localSaleId,
      clientRequestId: '550e8400-e29b-41d4-a716-446655440302',
      draft: SaleDraft(
        clientId: '203',
        clientName: 'Empório do Bairro',
        items: [
          const SaleDraftItem(
            productId: '105',
            productName: 'Granola Artesanal 350g',
            productSku: 'ALI-105',
            quantity: 2,
            historicalUnitPrice: 18.90,
          ),
        ],
        soldAt: now,
        timezone: 'America/Sao_Paulo',
      ),
      createdAt: now,
    );
    await collection.commitPage(
      await collection.fetchPage(
        const SyncCheckpoint(checkpoint: 'seeded:2020-01'),
      ),
    );
    final sales = await DriftSalesRepository(database).watchSalesSummary().first;
    expect(sales, hasLength(3));
    expect(
      sales.singleWhere((sale) => sale.localSaleId == localSaleId).status,
      SaleSyncStatus.pending,
    );
    expect(
      await database.select(database.localSaleItemsTable).get(),
      hasLength(3),
    );
  });
}
