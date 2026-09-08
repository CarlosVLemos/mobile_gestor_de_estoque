enum AuthFailureKind {
  invalidCredentials,
  accountInactive,
  tenantInactive,
  passwordChangeRequired,
  invalidCurrentPassword,
  unauthorized,
  unavailable,
  validation,
  rateLimited,
  forbidden,
  unknown,
}

class AuthFailure {
  const AuthFailure(
    this.kind,
    this.message, {
    this.code,
    this.fieldErrors = const {},
  });
  final AuthFailureKind kind;
  final String message;
  final String? code;
  final Map<String, String> fieldErrors;
}
