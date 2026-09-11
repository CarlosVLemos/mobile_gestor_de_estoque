import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/features/sales/data/repositories/drift_sales_draft_repository.dart';

void main() {
  test('referências de venda vêm de clients/products Drift reais', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database
        .into(database.clientsTable)
        .insert(
          ClientsTableCompanion.insert(
            id: '201',
            name: 'Cliente Drift',
            city: const Value('Belém'),
            state: const Value('PA'),
          ),
        );
    await database
        .into(database.productsTable)
        .insert(
          ProductsTableCompanion.insert(
            id: '101',
            name: 'Produto Drift',
            sku: 'SKU-101',
            price: const Value(10),
            stockQuantity: 3,
            stockStatus: 'available',
            isAvailableForSale: true,
          ),
        );

    final seed = await DriftSalesDraftRepository(
      database,
      canViewFinancial: true,
    ).watchDraftSeed().first;
    expect(seed.clients.single.id, '201');
    expect(seed.clients.single.city, 'Belém - PA');
    expect(seed.products.single.id, '101');
    expect(seed.products.single.price, 10);
    expect(seed.clients.any((item) => item.id == 'client-1'), isFalse);
    expect(seed.products.any((item) => item.id == 'prod-1'), isFalse);
  });
}
