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
}

final _validPage = {
  'data': const [],
  'tombstones': const [],
  'meta': {'next_cursor': null, 'has_more': false, 'target_checkpoint': '2026-09-09T12:00:00Z'},
};
