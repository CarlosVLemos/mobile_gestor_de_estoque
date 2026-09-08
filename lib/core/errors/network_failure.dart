import 'api_exception.dart';
import 'failure.dart';

class NetworkFailure extends Failure {
  final Map<String, String>? validationErrors;

  const NetworkFailure._(super.message, {this.validationErrors});

  factory NetworkFailure.connectivity({
    String message = 'Sem conexão com o servidor. Verifique sua internet.',
  }) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.timeout({
    String message =
        'O servidor demorou muito para responder. Tente novamente.',
  }) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.unauthorized({
    String message = 'Sessão expirada. Por favor, faça login novamente.',
  }) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.forbidden({
    String message = 'Você não tem permissão para realizar esta ação.',
  }) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.invalidParams(
    Map<String, String> fields, {
    String message = 'Verifique os dados preenchidos.',
  }) {
    return NetworkFailure._(message, validationErrors: fields);
  }

  factory NetworkFailure.server({
    String message = 'Erro no servidor. Nossa equipe já foi notificada.',
  }) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.rateLimited({
    String message =
        'Muitas solicitações em pouco tempo. Tente novamente mais tarde.',
  }) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.unknown(String message) {
    return NetworkFailure._(message);
  }
}

extension ApiExceptionToNetworkFailure on ApiException {
  NetworkFailure toNetworkFailure() {
    return switch (this) {
      NoInternetException(:final message) => NetworkFailure.connectivity(
        message: message,
      ),
      ConnectionTimeoutException(:final message) => NetworkFailure.timeout(
        message: message,
      ),
      UnauthorizedException(:final message) => NetworkFailure.unauthorized(
        message: message,
      ),
      ForbiddenException(:final message) => NetworkFailure.forbidden(
        message: message,
      ),
      InvalidParamsException(:final message, :final errors) =>
        NetworkFailure.invalidParams(
          _normalizeValidationErrors(errors),
          message: message,
        ),
      RateLimitException(:final message) => NetworkFailure.rateLimited(
        message: message,
      ),
      ServerException(:final message) => NetworkFailure.server(
        message: message,
      ),
      UnknownException(:final message) => NetworkFailure.unknown(message),
    };
  }
}

Map<String, String> _normalizeValidationErrors(Map<String, dynamic> errors) {
  return {
    for (final entry in errors.entries)
      entry.key: switch (entry.value) {
        Iterable<Object?> values => values.join(' '),
        null => '',
        final Object value => value.toString(),
      },
  };
}
