import 'package:drift/native.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_checkpoint_store.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/features/catalog/data/remote/product_remote_data_source.dart';
import 'package:gestor_de_estoque/features/catalog/data/repositories/drift_catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/data/sync/product_sync_collection.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';

void main() {
  late AppDatabase database;
  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('final product page promotes target checkpoint only after its data transaction', () async {
    final collection = ProductSyncCollection(database: database, remote: _Remote(_page(hasMore: false)));
    final page = await collection.fetchPage(const SyncCheckpoint());
    await collection.commitPage(page);
    final checkpoint = await DriftSyncCheckpointStore(database).read('products');
    expect(checkpoint.cursor, isNull);
    expect(checkpoint.targetCheckpoint, isNull);
    expect(checkpoint.checkpoint, '2026-09-09T12:00:00.000Z');
    expect((await database.select(database.productsTable).getSingle()).price, isNull);
  });

  test('an active product clears an existing tombstone and upserts its category', () async {
    final collection = ProductSyncCollection(database: database, remote: _Remote(_page(hasMore: false)));
    await collection.commitPage(await collection.fetchPage(const SyncCheckpoint()));
    final deleteCollection = ProductSyncCollection(database: database, remote: _Remote(_page(hasMore: false, products: const [], tombstones: const [_Tombstone('p', '2026-09-10T12:00:00Z')])));
    await deleteCollection.commitPage(await deleteCollection.fetchPage(const SyncCheckpoint()));
    expect((await database.select(database.productsTable).getSingle()).deletedAt, isNotNull);
    await collection.commitPage(await collection.fetchPage(const SyncCheckpoint()));
    expect((await database.select(database.productsTable).getSingle()).deletedAt, isNull);
    expect((await database.select(database.categoriesTable).getSingle()).name, 'Categoria');
  });

  test('intermediate page persists the opaque cursor and stable target only after commit', () async {
    final collection = ProductSyncCollection(database: database, remote: _Remote(_page(hasMore: true)));
    final page = await collection.fetchPage(const SyncCheckpoint());
    expect((await DriftSyncCheckpointStore(database).read('products')).cursor, isNull);
    await collection.commitPage(page);
    final saved = await DriftSyncCheckpointStore(database).read('products');
    expect(saved.cursor, 'opaque+cursor');
    expect(saved.targetCheckpoint, '2026-09-09T12:00:00.000Z');
    expect(saved.checkpoint, isNull);
  });

  test('a failed page transaction does not promote its cursor or write products', () async {
    final collection = ProductSyncCollection(database: database, remote: _Remote(_page(hasMore: true)));
    final page = await collection.fetchPage(const SyncCheckpoint());
    await database.customStatement('''
      CREATE TRIGGER reject_product_checkpoint BEFORE INSERT ON sync_collections
      BEGIN SELECT RAISE(ABORT, 'checkpoint failure'); END
    ''');
    await expectLater(collection.commitPage(page), throwsA(isA<Object>()));
    expect((await DriftSyncCheckpointStore(database).read('products')).cursor, isNull);
    expect(await database.select(database.productsTable).get(), isEmpty);
  });

  test('a product without category retains nullable category and price', () async {
    final collection = ProductSyncCollection(
      database: database,
      remote: _Remote(_page(
        hasMore: false,
        products: const [
          {
            'id': 'no-category',
            'name': 'Produto sem categoria',
            'sku': 'SKU-NONE',
            'brand': null,
            'price': null,
            'stock_quantity': 0,
            'stock_status': 'out',
            'is_available_for_sale': false,
            'image_url': null,
            'updated_at': null,
            'category': null,
          },
        ],
      )),
    );
    await collection.commitPage(await collection.fetchPage(const SyncCheckpoint()));
    final product = await database.select(database.productsTable).getSingle();
    expect(product.categoryId, isNull);
    expect(product.price, isNull);
    expect(product.brand, isNull);
  });

  test('current financial permission masks a cached product price', () async {
    final collection = ProductSyncCollection(
      database: database,
      remote: _Remote(_page(
        hasMore: false,
        products: [
          {
            'id': 'priced',
            'name': 'Produto',
            'sku': 'SKU-PRICE',
            'brand': null,
            'price': 100,
            'stock_quantity': 1,
            'stock_status': 'available',
            'is_available_for_sale': true,
            'image_url': null,
            'updated_at': null,
            'category': null,
          },
        ],
      )),
    );
    await collection.commitPage(await collection.fetchPage(const SyncCheckpoint()));
    final repository = DriftCatalogRepository(
      database,
      hasCatalogFeature: true,
      canViewProducts: true,
      canViewFinancialMetrics: false,
    );
    final result = await repository.load(const CatalogQuery());
    expect(result.items.single.price, isNull);
  });
}

class _Remote extends ProductRemoteDataSource {
  _Remote(this.page) : super(ApiClient(Dio()), accessToken: 'test-token');
  final Map<String, dynamic> page;
  @override Future<RemoteProductPage> fetch({String? cursor, String? checkpoint}) async => RemoteProductPage(page);
}

Map<String, dynamic> _page({required bool hasMore, List<Map<String, dynamic>>? products, List<_Tombstone> tombstones = const []}) => {
  'data': products ?? [{'id': 'p', 'name': 'Produto', 'sku': 'SKU', 'brand': null, 'price': null, 'stock_quantity': 1, 'stock_status': 'available', 'is_available_for_sale': true, 'image_url': null, 'updated_at': null, 'category': {'id': 'c', 'name': 'Categoria'}}],
  'tombstones': [for (final tombstone in tombstones) {'id': tombstone.id, 'deleted_at': tombstone.deletedAt}],
  'meta': {'next_cursor': hasMore ? 'opaque+cursor' : null, 'has_more': hasMore, 'target_checkpoint': '2026-09-09T12:00:00Z'},
};
class _Tombstone { const _Tombstone(this.id, this.deletedAt); final String id, deletedAt; }
