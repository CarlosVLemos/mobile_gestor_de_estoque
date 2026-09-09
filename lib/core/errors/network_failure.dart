import 'api_exception.dart';
import 'failure.dart';

enum NetworkFailureKind {
  connectivity,
  timeout,
  cancelled,
  unauthorized,
  forbidden,
  invalidParams,
  server,
  rateLimited,
  unknown,
}

class NetworkFailure extends Failure {
  final NetworkFailureKind kind;
  final Map<String, String>? validationErrors;

  const NetworkFailure._(
    super.message, {
    required this.kind,
    this.validationErrors,
  });

  factory NetworkFailure.connectivity({
    String message = 'Sem conexão com o servidor. Verifique sua internet.',
  }) {
    return NetworkFailure._(message, kind: NetworkFailureKind.connectivity);
  }

  factory NetworkFailure.timeout({
    String message =
        'O servidor demorou muito para responder. Tente novamente.',
  }) {
    return NetworkFailure._(message, kind: NetworkFailureKind.timeout);
  }

  factory NetworkFailure.cancelled({String message = 'Requisição cancelada.'}) {
    return NetworkFailure._(message, kind: NetworkFailureKind.cancelled);
  }

  factory NetworkFailure.unauthorized({
    String message = 'Sessão expirada. Por favor, faça login novamente.',
  }) {
    return NetworkFailure._(message, kind: NetworkFailureKind.unauthorized);
  }

  factory NetworkFailure.forbidden({
    String message = 'Você não tem permissão para realizar esta ação.',
  }) {
    return NetworkFailure._(message, kind: NetworkFailureKind.forbidden);
  }

  factory NetworkFailure.invalidParams(
    Map<String, String> fields, {
    String message = 'Verifique os dados preenchidos.',
  }) {
    return NetworkFailure._(
      message,
      kind: NetworkFailureKind.invalidParams,
      validationErrors: fields,
    );
  }

  factory NetworkFailure.server({
    String message = 'Erro no servidor. Nossa equipe já foi notificada.',
  }) {
    return NetworkFailure._(message, kind: NetworkFailureKind.server);
  }

  factory NetworkFailure.rateLimited({
    String message =
        'Muitas solicitações em pouco tempo. Tente novamente mais tarde.',
  }) {
    return NetworkFailure._(message, kind: NetworkFailureKind.rateLimited);
  }

  factory NetworkFailure.unknown(String message) {
    return NetworkFailure._(message, kind: NetworkFailureKind.unknown);
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
      RequestCancelledException(:final message) => NetworkFailure.cancelled(
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
      ProtocolException(:final message) => NetworkFailure.unknown(message),
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
