import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/drift_sync_checkpoint_store.dart';
import '../../../../core/sync/sync_collection.dart';
import '../remote/product_remote_data_source.dart';

class ProductSyncCollection implements SyncCollection {
  ProductSyncCollection({required this.database, required this.remote});

  final AppDatabase database;
  final ProductRemoteDataSource remote;

  @override
  String get name => 'products';

  @override
  Future<SyncCheckpoint> readCheckpoint() async {
    final saved = await DriftSyncCheckpointStore(database).read(name);
    // Offset/page não é cursor estável. Repetir a janela desde a página 1 em
    // nova execução evita confiar num offset envelhecido após interrupção.
    return SyncCheckpoint(lastSyncedAt: saved.lastSyncedAt);
  }

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint) async {
    final page = checkpoint.cursor == null ? 1 : int.parse(checkpoint.cursor!);
    final response = await remote.fetch(page: page, updatedSince: checkpoint.lastSyncedAt);
    return _ProductPage(
      response.products,
      response.hasMore,
      SyncCheckpoint(
        // Não promover max(updated_at) a watermark de snapshot inexistente.
        lastSyncedAt: checkpoint.lastSyncedAt,
        cursor: response.hasMore ? '${page + 1}' : null,
      ),
    );
  }

  @override
  Future<void> commitPage(SyncPage page) {
    if (page is! _ProductPage) throw ArgumentError('Página de outra coleção.');
    return DriftSyncCheckpointStore(database).commitPage(
      collection: name,
      checkpoint: page.checkpoint,
      writeData: () async {
        await database.batch((batch) {
          final categories = <String, CategoriesTableCompanion>{};
          for (final product in page.products) {
            if (product.categoryId != null) {
              categories[product.categoryId!] = CategoriesTableCompanion.insert(
                id: product.categoryId!,
                name: product.categoryName!,
              );
            }
          }
          batch.insertAllOnConflictUpdate(database.categoriesTable, categories.values);
          batch.insertAllOnConflictUpdate(
            database.productsTable,
            page.products.map((product) => ProductsTableCompanion.insert(
              id: product.id,
              name: product.name,
              sku: product.sku,
              brand: product.brand,
              price: Value(product.price),
              stockQuantity: product.stockQuantity,
              stockStatus: product.stockStatus,
              isAvailableForSale: product.isAvailableForSale,
              imageUrl: Value(product.imageUrl),
              categoryId: Value(product.categoryId),
              updatedAt: product.updatedAt,
            )),
          );
        });
      },
    );
  }
}

class _ProductPage implements SyncPage {
  _ProductPage(this.products, this.hasMore, this.checkpoint);

  final List<RemoteProduct> products;
  @override
  final bool hasMore;
  @override
  final SyncCheckpoint checkpoint;
}
