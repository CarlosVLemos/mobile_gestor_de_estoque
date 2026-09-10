import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/core/sync/sync_exception.dart';
import 'package:gestor_de_estoque/features/catalog/data/remote/product_remote_data_source.dart';

void main() {
  test('sends an opaque cursor unchanged and never uses page', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    late RequestOptions request;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response(requestOptions: options, data: _validPage));
    }));

    await ProductRemoteDataSource(
      ApiClient(dio),
      accessToken: 'test-token',
    ).fetch(
      cursor: 'eyJ0ZW5hbnQiOiJ4In0+/=',
      checkpoint: '2026-09-09T10:00:00.000Z',
    );

    expect(request.path, '/api/mobile/products');
    expect(request.queryParameters['cursor'], 'eyJ0ZW5hbnQiOiJ4In0+/=');
    expect(request.queryParameters['checkpoint'], '2026-09-09T10:00:00.000Z');
    expect(request.queryParameters['per_page'], 50);
    expect(request.queryParameters.containsKey('page'), isFalse);
    expect(request.headers['Authorization'], 'Bearer test-token');
  });

  test('maps an invalid products envelope to invalidData', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.resolve(Response(requestOptions: options, data: {'data': []}));
    }));
    await expectLater(
      ProductRemoteDataSource(
        ApiClient(dio),
        accessToken: 'test-token',
      ).fetch(),
      throwsA(isA<SyncException>().having((value) => value.kind, 'kind', SyncFailureKind.invalidData)),
    );
  });

  test('accepts numeric product and tombstone IDs with a UUID category', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.resolve(Response(requestOptions: options, data: {
        'data': [
          {
            'id': 123,
            'name': 'Produto',
            'sku': 'SKU-123',
            'brand': null,
            'price': null,
            'stock_quantity': 1,
            'stock_status': 'available',
            'is_available_for_sale': true,
            'image_url': null,
            'updated_at': null,
            'category': {
              'id': '550e8400-e29b-41d4-a716-446655440000',
              'name': 'Categoria',
            },
          },
        ],
        'tombstones': [
          {'id': 999, 'deleted_at': '2026-09-09T12:00:00Z'},
        ],
        'meta': {
          'next_cursor': null,
          'has_more': false,
          'target_checkpoint': '2026-09-09T12:00:00Z',
        },
      }));
    }));

    final page = await ProductRemoteDataSource(
      ApiClient(dio),
      accessToken: 'test-token',
    ).fetch();

    expect(page.products.single.id, '123');
    expect(
      page.products.single.category?.id,
      '550e8400-e29b-41d4-a716-446655440000',
    );
    expect(page.tombstones.single.id, '999');
  });

  test('accepts a product without category', () {
    final page = RemoteProductPage(
      _pageWith(
        productId: 123,
        category: null,
        tombstoneId: 999,
      ),
    );

    expect(page.products.single.id, '123');
    expect(page.products.single.category, isNull);
    expect(page.tombstones.single.id, '999');
  });

  test('rejects a UUID or arbitrary text as a product ID', () {
    for (final invalidId in [
      '550e8400-e29b-41d4-a716-446655440000',
      'prod-1',
    ]) {
      expect(
        () => RemoteProductPage(
          _pageWith(
            productId: invalidId,
            category: null,
            tombstoneId: 999,
          ),
        ),
        throwsFormatException,
      );
    }
  });

  test('rejects a UUID or arbitrary text as a product tombstone ID', () {
    for (final invalidId in [
      '550e8400-e29b-41d4-a716-446655440000',
      'prod-1',
    ]) {
      expect(
        () => RemoteProductPage(
          _pageWith(
            productId: 123,
            category: null,
            tombstoneId: invalidId,
          ),
        ),
        throwsFormatException,
      );
    }
  });

  test('rejects a non-UUID category ID', () {
    expect(
      () => RemoteProductPage(
        _pageWith(
          productId: 123,
          category: {'id': 45, 'name': 'Categoria'},
          tombstoneId: 999,
        ),
      ),
      throwsFormatException,
    );
  });
}

final _validPage = {
  'data': const [],
  'tombstones': const [],
  'meta': {'next_cursor': null, 'has_more': false, 'target_checkpoint': '2026-09-09T12:00:00Z'},
};

Map<String, dynamic> _pageWith({
  required Object productId,
  required Map<String, dynamic>? category,
  required Object tombstoneId,
}) => {
  'data': [
    {
      'id': productId,
      'name': 'Produto',
      'sku': 'SKU-123',
      'brand': null,
      'price': null,
      'stock_quantity': 1,
      'stock_status': 'available',
      'is_available_for_sale': true,
      'image_url': null,
      'updated_at': null,
      'category': category,
    },
  ],
  'tombstones': [
    {'id': tombstoneId, 'deleted_at': '2026-09-09T12:00:00Z'},
  ],
  'meta': {
    'next_cursor': null,
    'has_more': false,
    'target_checkpoint': '2026-09-09T12:00:00Z',
  },
};
