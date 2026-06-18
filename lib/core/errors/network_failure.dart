import 'failure.dart';

class NetworkFailure extends Failure {
  final Map<String, String>? validationErrors;

  const NetworkFailure._(super.message, {this.validationErrors});

  factory NetworkFailure.connectivity({String message = 'Sem conexão com o servidor. Verifique sua internet.'}) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.timeout({String message = 'O servidor demorou muito para responder. Tente novamente.'}) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.unauthorized({String message = 'Sessão expirada. Por favor, faça login novamente.'}) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.forbidden({String message = 'Você não tem permissão para realizar esta ação.'}) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.invalidParams(Map<String, String> fields, {String message = 'Verifique os dados preenchidos.'}) {
    return NetworkFailure._(message, validationErrors: fields);
  }

  factory NetworkFailure.server({String message = 'Erro no servidor. Nossa equipe já foi notificada.'}) {
    return NetworkFailure._(message);
  }

  factory NetworkFailure.unknown(String message) {
    return NetworkFailure._(message);
  }
}
