import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/drift_sync_checkpoint_store.dart';
import '../../../../core/sync/sync_collection.dart';
import '../remote/product_remote_data_source.dart';

class ProductSyncCollection implements SyncCollection, CancellableSyncCollection {
  ProductSyncCollection({required this.database, required this.remote}) : _store = DriftSyncCheckpointStore(database);
  final AppDatabase database;
  final ProductRemoteDataSource remote;
  final DriftSyncCheckpointStore _store;
  @override String get name => 'products';
  @override Future<SyncCheckpoint> readCheckpoint() => _store.read(name);

  @override
  Future<SyncPage> fetchPage(SyncCheckpoint saved) async {
    final response = await remote.fetch(cursor: saved.cursor, checkpoint: saved.targetCheckpoint ?? saved.checkpoint);
    final target = saved.targetCheckpoint ?? response.targetCheckpoint.toIso8601String();
    if (saved.targetCheckpoint != null && saved.targetCheckpoint != response.targetCheckpoint.toIso8601String()) {
      throw const FormatException('Target checkpoint mudou durante a janela.');
    }
    final complete = !response.hasMore;
    return _ProductPage(response, SyncCheckpoint(
      mode: complete ? 'delta' : (saved.isBootstrapped ? 'delta' : 'bootstrap'),
      cursor: complete ? null : response.nextCursor,
      checkpoint: complete ? target : saved.checkpoint,
      targetCheckpoint: complete ? null : target,
      isBootstrapped: complete || saved.isBootstrapped,
      totalReceived: saved.totalReceived + response.products.length + response.tombstones.length,
    ));
  }

  @override
  Future<void> commitPage(SyncPage page) {
    if (page is! _ProductPage) throw ArgumentError.value(page, 'page');
    return _store.commitPage(collection: name, checkpoint: page.checkpoint, writeData: () async {
      await database.batch((batch) {
        for (final tombstone in page.response.tombstones) {
          batch.update(
            database.productsTable,
            ProductsTableCompanion(deletedAt: Value(tombstone.deletedAt)),
            where: (row) => row.id.equals(tombstone.id),
          );
        }
        final categories = <String, CategoriesTableCompanion>{};
        for (final product in page.response.products) { final category = product.category; if (category != null) categories[category.id] = CategoriesTableCompanion.insert(id: category.id, name: category.name); }
        batch.insertAllOnConflictUpdate(database.categoriesTable, categories.values);
        batch.insertAllOnConflictUpdate(database.productsTable, page.response.products.map((product) => ProductsTableCompanion.insert(
          id: product.id, name: product.name, sku: product.sku, brand: Value(product.brand), price: Value(product.price), stockQuantity: product.stockQuantity,
          stockStatus: product.stockStatus, isAvailableForSale: product.isAvailableForSale, imageUrl: Value(product.imageUrl), categoryId: Value(product.category?.id), remoteUpdatedAt: Value(product.updatedAt), deletedAt: const Value(null),
        )));
      });
    });
  }
  @override void cancelPendingRequest() => remote.cancelPendingRequest();
}
class _ProductPage implements SyncPage { const _ProductPage(this.response, this.checkpoint); final RemoteProductPage response; @override final SyncCheckpoint checkpoint; @override bool get hasMore => response.hasMore; }
