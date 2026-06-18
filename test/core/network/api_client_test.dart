import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/errors/api_exception.dart';
import 'package:gestor_de_estoque/core/errors/failure.dart' as domain;
import 'package:gestor_de_estoque/core/errors/network_failure.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/core/network/interceptors/redaction_interceptor.dart';
import 'package:gestor_de_estoque/core/result/result.dart';

class MockAdapter implements HttpClientAdapter {
  ResponseBody Function(RequestOptions)? handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (handler != null) {
      return handler!(options);
    }
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('RedactionInterceptor Tests', () {
    late List<String> logs;
    late RedactionInterceptor interceptor;
    late Dio dio;
    late MockAdapter mockAdapter;

    setUp(() {
      logs = [];
      interceptor = RedactionInterceptor(
        logPrint: (log) => logs.add(log),
        logRequest: true,
        logResponse: true,
        logError: true,
      );
      dio = Dio();
      dio.interceptors.add(interceptor);
      mockAdapter = MockAdapter();
      dio.httpClientAdapter = mockAdapter;
    });

    test('Censura headers sensíveis nos logs de requisição e resposta', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString(
          '{"status": "ok"}',
          200,
          headers: {
            'set-cookie': ['token-de-sessao-cookie'],
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      };

      await dio.get(
        'https://example.test/api',
        options: Options(
          headers: {
            'Authorization': 'Bearer token-super-secreto',
            'X-Tenant-ID': 'tenant-slug-id',
            'Accept': 'application/json',
          },
        ),
      );

      final requestLogs = logs.join('\n');

      // Verifica se as chaves sensíveis foram censuradas nos logs de Request
      expect(requestLogs, contains('Authorization: [REDACTED]'));
      expect(requestLogs, contains('X-Tenant-ID: [REDACTED]'));
      expect(requestLogs, contains('Accept: application/json'));

      // Verifica se as chaves sensíveis foram censuradas nos logs de Response
      expect(requestLogs, contains('set-cookie: [REDACTED]'));

      // E que as credenciais originais NÃO foram substituídas nas opções de requisição que o Dio envia de verdade
      expect(dio.options.headers['Authorization'], isNull); // Configurações globais não mudam
    });

    test('Censura campos sensíveis no corpo JSON da requisição', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString('{}', 200);
      };

      await dio.post(
        'https://example.test/login',
        data: {
          'email': 'maria@example.test',
          'password': 'minha-senha-secreta',
          'token': 'token-temp',
          'client_secret': 'chave-do-cliente',
        },
      );

      final logOutput = logs.join('\n');

      expect(logOutput, contains('email: maria@example.test'));
      expect(logOutput, contains('password: [REDACTED]'));
      expect(logOutput, contains('token: [REDACTED]'));
      expect(logOutput, contains('client_secret: [REDACTED]'));
    });

    test('Censura campos sensíveis em parâmetros de query string', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString('{}', 200);
      };

      await dio.get(
        'https://example.test/auth',
        queryParameters: {
          'scope': 'read',
          'token': 'token-na-url',
          'client_secret': 'segredo-url',
        },
      );

      final logOutput = logs.join('\n');

      expect(logOutput, contains('scope: read'));
      expect(logOutput, contains('token: [REDACTED]'));
      expect(logOutput, contains('client_secret: [REDACTED]'));
    });
  });

  group('ApiClient Exception Mapping Tests', () {
    late Dio dio;
    late MockAdapter mockAdapter;
    late ApiClient apiClient;

    setUp(() {
      dio = Dio();
      mockAdapter = MockAdapter();
      dio.httpClientAdapter = mockAdapter;
      apiClient = ApiClient(dio);
    });

    test('Mapeamento de 401 Unauthorized', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString('{}', 401);
      };

      expect(
        () => apiClient.get('https://example.test'),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('Mapeamento de 403 Forbidden', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString('{}', 403);
      };

      expect(
        () => apiClient.get('https://example.test'),
        throwsA(isA<ForbiddenException>()),
      );
    });

    test('Mapeamento de 422 Unprocessable Entity (Erros Laravel)', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString(
          json.encode({
            'message': 'Os campos são inválidos.',
            'errors': {
              'email': ['O campo email é obrigatório.'],
              'password': ['A senha deve conter pelo menos 6 caracteres.']
            }
          }),
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      };

      try {
        await apiClient.post('https://example.test/submit');
        fail('Deveria ter lançado InvalidParamsException');
      } catch (e) {
        expect(e, isA<InvalidParamsException>());
        final ex = e as InvalidParamsException;
        expect(ex.message, equals('Os campos são inválidos.'));
        expect(ex.errors['email'], contains('O campo email é obrigatório.'));
        expect(ex.errors['password'], contains('A senha deve conter pelo menos 6 caracteres.'));
      }
    });

    test('Mapeamento de 429 Too Many Requests', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString('{}', 429);
      };

      expect(
        () => apiClient.get('https://example.test'),
        throwsA(isA<RateLimitException>()),
      );
    });

    test('Mapeamento de 5xx Server Error', () async {
      mockAdapter.handler = (options) {
        return ResponseBody.fromString('{}', 503);
      };

      try {
        await apiClient.get('https://example.test');
        fail('Deveria ter lançado ServerException');
      } catch (e) {
        expect(e, isA<ServerException>());
        final ex = e as ServerException;
        expect(ex.statusCode, equals(503));
      }
    });

    test('Mapeamento de falha física (Timeout)', () async {
      mockAdapter.handler = (options) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection Timeout',
        );
      };

      expect(
        () => apiClient.get('https://example.test'),
        throwsA(isA<ConnectionTimeoutException>()),
      );
    });

    test('Mapeamento de falha física (Falta de Internet / SocketException)', () async {
      mockAdapter.handler = (options) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const SocketException('No Internet Connection'),
        );
      };

      expect(
        () => apiClient.get('https://example.test'),
        throwsA(isA<NoInternetException>()),
      );
    });
  });

  group('Result Type Tests', () {
    test('Success envelope behaves correctly', () {
      const Result<String, String> result = Success<String, String>('sucesso');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.successOrNull, equals('sucesso'));
      expect(result.failureOrNull, isNull);

      final foldVal = result.fold(
        (val) => 'OK: $val',
        (err) => 'FAIL: $err',
      );
      expect(foldVal, equals('OK: sucesso'));

      // Pattern matching switch test
      final switchVal = switch (result) {
        Success(:final value) => 'Val: $value',
        Failure(:final error) => 'Err: $error',
      };
      expect(switchVal, equals('Val: sucesso'));
    });

    test('Failure envelope behaves correctly', () {
      final failureValue = NetworkFailure.connectivity();
      final result = Failure<String, domain.Failure>(failureValue);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.successOrNull, isNull);
      expect(result.failureOrNull, equals(failureValue));

      final foldVal = result.fold(
        (val) => 'OK: $val',
        (err) => 'FAIL: ${err.message}',
      );
      expect(foldVal, contains('Sem conexão com o servidor.'));
    });
  });
}
