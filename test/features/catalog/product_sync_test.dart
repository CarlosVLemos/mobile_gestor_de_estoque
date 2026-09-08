import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_checkpoint_store.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_lease_store.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/core/sync/sync_exception.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';
import 'package:gestor_de_estoque/core/sync/sync_state.dart';
import 'package:gestor_de_estoque/features/catalog/data/remote/product_remote_data_source.dart';
import 'package:gestor_de_estoque/features/catalog/data/repositories/drift_product_repository.dart';
import 'package:gestor_de_estoque/features/catalog/data/sync/product_sync_collection.dart';
import 'package:gestor_de_estoque/features/catalog/domain/entities/catalog_read_access.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';

void main() {
  late AppDatabase database;
  late Dio dio;
  late SyncEngine engine;
  late ProductSyncCollection collection;
  late List<RequestOptions> requests;
  int? failPage;
  int? responseStatus;
  bool invalidPrice = false;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    requests = [];
    failPage = null;
    responseStatus = null;
    invalidPrice = false;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      requests.add(options);
      final page = options.queryParameters['page'] as int;
      if (page == failPage || responseStatus != null) {
        handler.reject(DioException(
          requestOptions: options,
          type: responseStatus == null ? DioExceptionType.connectionError : DioExceptionType.badResponse,
          response: responseStatus == null ? null : Response(requestOptions: options, statusCode: responseStatus),
        ));
        return;
      }
      handler.resolve(Response(requestOptions: options, statusCode: 200, data: {
        'data': [{
          'id': 'product-$page', 'name': 'Produto $page', 'sku': 'SKU-$page',
          'brand': 'Marca', 'price': invalidPrice ? 'inválido' : (page == 1 ? null : 12.5),
          'stock_quantity': 0, 'stock_status': 'out', 'is_available_for_sale': false,
          'image_url': null, 'updated_at': '2026-09-08T12:00:00Z',
          'category': {'id': 'category-1', 'name': 'Peças'},
        }],
        'meta': {'current_page': page, 'last_page': 2, 'has_more_pages': page < 2},
      }));
    }));
    collection = ProductSyncCollection(database: database, remote: ProductRemoteDataSource(ApiClient(dio)));
    engine = SyncEngine(
      collections: [collection], lock: SyncLock(),
      leaseStore: DriftSyncLeaseStore(database: database, ttl: const Duration(minutes: 2)),
    );
  });

  tearDown(() async {
    await engine.dispose();
    dio.close();
    await database.close();
  });

  test('pagina em lotes de 50, categorias antes dos produtos e upsert idempotente', () async {
    expect(await engine.sync(), SyncOutcome.succeeded);
    expect(requests.map((r) => r.queryParameters['page']), [1, 2]);
    for (final request in requests) {
      expect(request.path, '/api/mobile/products');
      expect(request.queryParameters['per_page'], 50);
      expect(request.queryParameters.containsKey('limit'), isFalse);
      expect(request.queryParameters.containsKey('updated_since'), isFalse);
    }
    final rows = await database.select(database.productsTable).get();
    expect(rows, hasLength(2));
    expect(rows.singleWhere((p) => p.id == 'product-1').price, isNull);
    expect(rows.singleWhere((p) => p.id == 'product-2').price, 12.5);
    expect(await database.select(database.categoriesTable).get(), hasLength(1));
    expect(await engine.sync(), SyncOutcome.succeeded);
    expect(await database.select(database.productsTable).get(), hasLength(2));
  });

  test('falha na segunda página preserva dados e nova execução repete janela', () async {
    failPage = 2;
    expect(await engine.sync(), SyncOutcome.failed);
    expect(engine.state.failureKind, SyncFailureKind.offline);
    expect(await database.select(database.productsTable).get(), hasLength(1));
    expect((await DriftSyncCheckpointStore(database).read('products')).cursor, '2');
    failPage = null;
    expect(await engine.sync(), SyncOutcome.succeeded);
    expect(requests.map((r) => r.queryParameters['page']), [1, 2, 1, 2]);
    final checkpoint = await DriftSyncCheckpointStore(database).read('products');
    expect(checkpoint.cursor, isNull);
    expect(checkpoint.lastSyncedAt, isNull);
  });

  test('mantém updated_since confiável fixo em todas as páginas', () async {
    final since = DateTime.utc(2026, 8, 1);
    await DriftSyncCheckpointStore(database).commitPage(
      collection: 'products',
      checkpoint: SyncCheckpoint(lastSyncedAt: since),
      writeData: () async {},
    );
    expect(await engine.sync(), SyncOutcome.succeeded);
    expect(requests.every((r) => r.queryParameters['updated_since'] == since.toIso8601String()), isTrue);
    expect((await DriftSyncCheckpointStore(database).read('products')).lastSyncedAt!.toUtc(), since);
  });

  test('payload inválido aborta sem gravar página', () async {
    invalidPrice = true;
    expect(await engine.sync(), SyncOutcome.failed);
    expect(engine.state.failureKind, SyncFailureKind.invalidData);
    expect(await database.select(database.productsTable).get(), isEmpty);
    expect((await DriftSyncCheckpointStore(database).read('products')).isEmpty, isTrue);
  });

  for (final status in [401, 403, 429, 500]) {
    test('classifica HTTP $status sem descartar cache', () async {
      expect(await engine.sync(), SyncOutcome.succeeded);
      responseStatus = status;
      expect(await engine.sync(), SyncOutcome.failed);
      expect(engine.state.failureKind, switch (status) {
        401 => SyncFailureKind.unauthorized,
        403 => SyncFailureKind.forbidden,
        _ => SyncFailureKind.remote,
      });
      expect(await database.select(database.productsTable).get(), hasLength(2));
    });
  }

  test('repositório reage ao banco e aplica filtro e restrição financeira', () async {
    final repository = DriftProductRepository(database, const CatalogReadAccess(
      featureEnabled: true, canViewProducts: true, canViewFinancial: false,
    ));
    final updated = Completer<void>();
    final subscription = repository.watch(const CatalogQuery(search: 'SKU-2', category: 'Peças')).listen((result) {
      if (result.items.isNotEmpty && !updated.isCompleted) {
        expect(result.items.single.id, 'product-2');
        expect(result.items.single.price, isNull);
        expect(result.categories, ['Todos', 'Peças']);
        updated.complete();
      }
    });
    try {
      await engine.sync();
      await updated.future;
    } finally {
      await subscription.cancel();
    }
  });
}
