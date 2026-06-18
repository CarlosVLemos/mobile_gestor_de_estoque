import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/api_exception.dart';
import 'interceptors/redaction_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(const RedactionInterceptor());
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  ApiException _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ConnectionTimeoutException();
    }

    if (e.type == DioExceptionType.connectionError ||
        e.error is SocketException ||
        e.error is HttpException) {
      return const NoInternetException();
    }

    if (e.type == DioExceptionType.badResponse && e.response != null) {
      final response = e.response!;
      final statusCode = response.statusCode ?? 500;

      switch (statusCode) {
        case 401:
          return const UnauthorizedException();
        case 403:
          return const ForbiddenException();
        case 422:
          final responseData = response.data;
          Map<String, dynamic> validationErrors = {};
          String msg = 'Dados inválidos.';

          if (responseData is Map<String, dynamic>) {
            if (responseData['errors'] is Map<String, dynamic>) {
              validationErrors = responseData['errors'] as Map<String, dynamic>;
            }
            if (responseData['message'] is String) {
              msg = responseData['message'] as String;
            }
          }
          return InvalidParamsException(
            message: msg,
            errors: validationErrors,
          );
        case 429:
          return const RateLimitException();
        default:
          if (statusCode >= 500) {
            return ServerException(statusCode: statusCode);
          }
      }
    }

    return UnknownException(e.message ?? e.toString());
  }
}
