sealed class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class NoInternetException extends ApiException {
  const NoInternetException([super.message = 'Sem conexão com a internet.']);
}

class ConnectionTimeoutException extends ApiException {
  const ConnectionTimeoutException([
    super.message = 'Tempo limite de conexão excedido.',
  ]);
}

class RequestCancelledException extends ApiException {
  const RequestCancelledException([super.message = 'Requisição cancelada.']);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([
    super.message = 'Sessão expirada ou não autorizada.',
  ]);
}

class ForbiddenException extends ApiException {
  final String? code;
  const ForbiddenException([
    super.message = 'Acesso proibido a esta funcionalidade.',
    this.code,
  ]);
}

class InvalidParamsException extends ApiException {
  final Map<String, dynamic> errors;
  final String? code;

  const InvalidParamsException({
    String message = 'Dados inválidos.',
    required this.errors,
    this.code,
  }) : super(message);

  @override
  String toString() => 'InvalidParamsException: $message, errors: $errors';
}

class RateLimitException extends ApiException {
  const RateLimitException([
    super.message =
        'Limite de requisições excedido. Tente novamente mais tarde.',
  ]);
}

/// Structured non-success response used by domain-specific protocols. The
/// response body is deliberately not included in [toString], because it may
/// contain short-lived secrets such as a confirmation token.
class ProtocolException extends ApiException {
  const ProtocolException({
    required this.statusCode,
    required this.code,
    required this.data,
    String message = 'A operação remota exige tratamento específico.',
  }) : super(message);

  final int statusCode;
  final String? code;
  final Map<String, dynamic> data;

  @override
  String toString() => 'ProtocolException ($statusCode, code: $code): $message';
}

class ServerException extends ApiException {
  final int? statusCode;

  const ServerException({
    String message = 'Erro interno no servidor.',
    this.statusCode,
  }) : super(message);

  @override
  String toString() => 'ServerException ($statusCode): $message';
}

class UnknownException extends ApiException {
  const UnknownException([super.message = 'Erro desconhecido.']);
}
