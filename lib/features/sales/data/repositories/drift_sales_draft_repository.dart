import '../../../../core/database/app_database.dart';
import '../../domain/entities/sale_reference_data.dart';
import '../../domain/repositories/sales_draft_repository.dart';

class DriftSalesDraftRepository implements ReactiveSalesDraftRepository {
  DriftSalesDraftRepository(this._database, {required this.canViewFinancial});

  final AppDatabase _database;
  final bool canViewFinancial;

  @override
  SalesDraftSeed loadDraftSeed() {
    throw StateError('A referência de vendas Drift deve ser observada.');
  }

  @override
  Stream<SalesDraftSeed> watchDraftSeed() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {_database.clientsTable, _database.productsTable},
        )
        .watch()
        .asyncMap((_) async {
          final clients = await _database.watchClients().first;
          final products = await _database.activeProducts().get();
          return SalesDraftSeed(
            clients: [
              for (final client in clients)
                SaleClientOption(
                  id: client.id,
                  name: client.name,
                  code: 'CLI-${client.id}',
                  city: [
                    ?client.city,
                    ?client.state,
                  ].join(' - '),
                ),
            ],
            products: [
              for (final product in products)
                if (product.isAvailableForSale)
                  SaleProductOption(
                    id: product.id,
                    name: product.name,
                    sku: product.sku,
                    price: canViewFinancial ? product.price : null,
                  ),
            ],
          );
        });
  }
}
