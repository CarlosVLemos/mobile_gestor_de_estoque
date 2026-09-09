import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/features/sales/data/remote/sale_intents_remote_data_source.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';

void main() {
  SaleIntentPayload payload() => SaleIntentPayload(
    clientRequestId: '11111111-2222-4333-8444-555555555555',
    clientId: 123,
    soldAt: '2026-09-09T12:00:00-03:00',
    timezone: 'America/Sao_Paulo',
    items: const [SaleIntentItem(productId: 456, quantity: 2)],
  );

  test('envia payload v1 numérico sem preços, tenant ou X-Request-ID', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    late RequestOptions request;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 201,
        data: {'code': 'intent_confirmed'},
      ));
    }));

    final outcome = await SaleIntentsRemoteDataSource(
      ApiClient(dio),
      accessToken: 'token',
    ).createIntent(payload());

    final body = request.data as Map<String, dynamic>;
    expect(request.path, '/api/mobile/sale-intents');
    expect(request.headers['Authorization'], 'Bearer token');
    expect(request.headers.containsKey('X-Request-ID'), isFalse);
    expect(body['payload_version'], 1);
    expect(body['client_request_id'], payload().clientRequestId);
    expect(body['client_id'], 123);
    final item = (body['items'] as List).single as Map<String, dynamic>;
    expect(item['product_id'], 456);
    expect(item.containsKey('price'), isFalse);
    expect(body['sold_at'], contains('-03:00'));
    expect(body.containsKey('price'), isFalse);
    expect(body.containsKey('tenant_id'), isFalse);
    expect(outcome.kind, SaleIntentOutcomeKind.confirmed);
  });

  test('409 requires_confirmation bloqueia para aceite sem inventar envelope', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 409,
          data: {
            'code': 'requires_confirmation',
          },
        ),
      ));
    }));

    final outcome = await SaleIntentsRemoteDataSource(
      ApiClient(dio),
      accessToken: 'token',
    ).createIntent(payload());

    expect(outcome.kind, SaleIntentOutcomeKind.requiresAcceptance);
  });

  test('200 replay só confirma com intent confirmado e extrai IDs', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'code': 'idempotent_replay',
          'intent': {'id': 91, 'state': 'confirmed'},
          'sale': {'id': 37},
        },
      ));
    }));

    final outcome = await SaleIntentsRemoteDataSource(
      ApiClient(dio),
      accessToken: 'token',
    ).createIntent(payload());

    expect(outcome.kind, SaleIntentOutcomeKind.confirmed);
    expect(outcome.remoteIntentId, '91');
    expect(outcome.remoteSaleId, '37');
  });

  test('200 replay genérico não é tratado como confirmado', () async {
    for (final intent in <Map<String, dynamic>>[
      {'id': 91, 'state': 'requires_confirmation'},
      {'state': 'confirmed'},
    ]) {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: {'code': 'idempotent_replay', 'intent': intent},
        ));
      }));

      final outcome = await SaleIntentsRemoteDataSource(
        ApiClient(dio),
        accessToken: 'token',
      ).createIntent(payload());

      expect(outcome.kind, SaleIntentOutcomeKind.permanentFailure);
      expect(outcome.code, 'unexpected_sale_intent_response');
    }
  });

  test('cancelamento controlado não é falha de transporte', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
      ));
    }));

    final outcome = await SaleIntentsRemoteDataSource(
      ApiClient(dio),
      accessToken: 'token',
    ).createIntent(payload());

    expect(outcome.kind, SaleIntentOutcomeKind.interrupted);
    expect(outcome.code, 'request_cancelled');
  });

  test('409 insufficient_stock e 410 são permanentes', () async {
    for (final scenario in <(int, String)>[
      (409, 'insufficient_stock'),
      (410, 'intent_expired'),
    ]) {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: scenario.$1,
            data: {'code': scenario.$2},
          ),
        ));
      }));
      final outcome = await SaleIntentsRemoteDataSource(
        ApiClient(dio),
        accessToken: 'token',
      ).createIntent(payload());
      expect(outcome.kind, SaleIntentOutcomeKind.permanentFailure);
      expect(outcome.code, scenario.$2);
    }
  });

  test('classifica 422, 403, 429 e 5xx sem usar apenas o HTTP', () async {
    final scenarios = <(int, Map<String, dynamic>, SaleIntentOutcomeKind)>[
      (422, {'code': 'invalid_sale'}, SaleIntentOutcomeKind.permanentFailure),
      (403, {'code': 'sales_forbidden'}, SaleIntentOutcomeKind.blocked),
      (429, const {}, SaleIntentOutcomeKind.retryableFailure),
      (503, const {}, SaleIntentOutcomeKind.retryableFailure),
    ];
    for (final scenario in scenarios) {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: scenario.$1,
            data: scenario.$2,
          ),
        ));
      }));
      final outcome = await SaleIntentsRemoteDataSource(
        ApiClient(dio),
        accessToken: 'token',
      ).createIntent(payload());
      expect(outcome.kind, scenario.$3);
    }
  });

  test('409 desconhecido falha fechado sem retry automático', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 409,
          data: {'code': 'future_conflict'},
        ),
      ));
    }));
    final outcome = await SaleIntentsRemoteDataSource(
      ApiClient(dio),
      accessToken: 'token',
    ).createIntent(payload());
    expect(outcome.kind, SaleIntentOutcomeKind.permanentFailure);
    expect(outcome.code, 'future_conflict');
  });
}
