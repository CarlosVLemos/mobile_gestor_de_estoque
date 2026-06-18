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
  const ConnectionTimeoutException([super.message = 'Tempo limite de conexão excedido.']);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Sessão expirada ou não autorizada.']);
}

class ForbiddenException extends ApiException {
  const ForbiddenException([super.message = 'Acesso proibido a esta funcionalidade.']);
}

class InvalidParamsException extends ApiException {
  final Map<String, dynamic> errors;

  const InvalidParamsException({
    String message = 'Dados inválidos.',
    required this.errors,
  }) : super(message);

  @override
  String toString() => 'InvalidParamsException: $message, errors: $errors';
}

class RateLimitException extends ApiException {
  const RateLimitException([super.message = 'Limite de requisições excedido. Tente novamente mais tarde.']);
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
