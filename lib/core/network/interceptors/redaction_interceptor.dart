import 'dart:convert';
import 'package:dio/dio.dart';

class RedactionInterceptor extends Interceptor {
  final void Function(String) logPrint;
  final bool logRequest;
  final bool logResponse;
  final bool logError;

  const RedactionInterceptor({
    this.logPrint = print,
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
  });

  static const _sensitiveKeys = {
    'authorization',
    'x-tenant-id',
    'cookie',
    'set-cookie',
    'password',
    'token',
    'client_secret',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      logPrint('*** Request ***');
      logPrint('Uri: ${options.uri}');
      logPrint('Method: ${options.method}');
      logPrint('Headers: ${_redactHeaders(options.headers)}');
      if (options.queryParameters.isNotEmpty) {
        logPrint('QueryParameters: ${_redactMap(options.queryParameters)}');
      }
      if (options.data != null) {
        logPrint('Body: ${_redactBody(options.data)}');
      }
      logPrint('');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      logPrint('*** Response ***');
      logPrint('Uri: ${response.requestOptions.uri}');
      logPrint('StatusCode: ${response.statusCode}');
      logPrint('Headers: ${_redactHeaders(response.headers.map)}');
      if (response.data != null) {
        logPrint('Body: ${_redactBody(response.data)}');
      }
      logPrint('');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      logPrint('*** DioException ***');
      logPrint('Uri: ${err.requestOptions.uri}');
      logPrint('Type: ${err.type}');
      logPrint('Message: ${err.message}');
      if (err.response != null) {
        logPrint('StatusCode: ${err.response?.statusCode}');
        logPrint('Response Headers: ${_redactHeaders(err.response?.headers.map ?? {})}');
        logPrint('Response Body: ${_redactBody(err.response?.data)}');
      }
      logPrint('');
    }
    super.onError(err, handler);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    final redacted = <String, dynamic>{};
    for (final entry in headers.entries) {
      final keyLower = entry.key.toLowerCase();
      if (_sensitiveKeys.contains(keyLower)) {
        redacted[entry.key] = '[REDACTED]';
      } else {
        redacted[entry.key] = entry.value;
      }
    }
    return redacted;
  }

  dynamic _redactBody(dynamic body) {
    if (body is Map<String, dynamic>) {
      return _redactMap(body);
    } else if (body is List) {
      return body.map((item) => _redactBody(item)).toList();
    } else if (body is String) {
      try {
        final decoded = json.decode(body);
        final redacted = _redactBody(decoded);
        return json.encode(redacted);
      } catch (_) {
        // Not a JSON string, check if it's query-like or return as is
        return body;
      }
    }
    return body;
  }

  Map<String, dynamic> _redactMap(Map<String, dynamic> map) {
    final redacted = <String, dynamic>{};
    for (final entry in map.entries) {
      final keyLower = entry.key.toLowerCase();
      if (_sensitiveKeys.contains(keyLower)) {
        redacted[entry.key] = '[REDACTED]';
      } else if (entry.value is Map<String, dynamic>) {
        redacted[entry.key] = _redactMap(entry.value as Map<String, dynamic>);
      } else if (entry.value is List) {
        redacted[entry.key] = (entry.value as List).map((item) => _redactBody(item)).toList();
      } else {
        redacted[entry.key] = entry.value;
      }
    }
    return redacted;
  }
}
