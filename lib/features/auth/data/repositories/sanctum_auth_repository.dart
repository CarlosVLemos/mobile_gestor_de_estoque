import '../../../../core/errors/api_exception.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../local/secure_token_storage.dart';
import '../remote/auth_remote_data_source.dart';

class SanctumAuthRepository implements AuthRepository {
  SanctumAuthRepository(this._remote, this._storage);
  final AuthRemoteDataSource _remote;
  final SecureTokenStorage _storage;

  @override
  Future<Result<UserSession, AuthFailure>> login({
    required String accessCode,
    required String password,
    required String deviceName,
  }) async {
    try {
      final response = await _remote.login({
        'access_code': accessCode,
        'password': password,
        'device_name': deviceName,
      });
      final token = response['token'];
      if (token is! String || token.isEmpty) {
        return const Failure(
          AuthFailure(AuthFailureKind.unknown, 'Resposta de login inválida.'),
        );
      }
      await _storage.write(token);
      return Success(
        _sessionFromProfile(
          await _remote.me(token),
          mustChangePassword: response['must_change_password'] == true,
        ),
      );
    } on ApiException catch (error) {
      return Failure(_failureFrom(error));
    }
  }

  @override
  Future<Result<UserSession, AuthFailure>> restoreSession() async {
    final token = await _storage.read();
    if (token == null || token.isEmpty) {
      return const Failure(
        AuthFailure(AuthFailureKind.unauthorized, 'Nenhuma sessão encontrada.'),
      );
    }
    try {
      return Success(_sessionFromProfile(await _remote.me(token)));
    } on ApiException catch (error) {
      return Failure(_failureFrom(error));
    }
  }

  @override
  Future<Result<void, AuthFailure>> changePassword({
    required String currentPassword,
    required String password,
    required String confirmation,
  }) async {
    final token = await _storage.read();
    if (token == null || token.isEmpty) {
      return const Failure(
        AuthFailure(AuthFailureKind.unauthorized, 'Sessão ausente.'),
      );
    }
    try {
      await _remote.changePassword(token, {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': confirmation,
      });
      return const Success(null);
    } on ApiException catch (error) {
      return Failure(_failureFrom(error));
    }
  }

  @override
  Future<Result<void, AuthFailure>> logout() async {
    final token = await _storage.read();
    if (token == null || token.isEmpty) return const Success(null);
    try {
      await _remote.logout(token);
      await _storage.clear();
      return const Success(null);
    } on UnauthorizedException {
      await _storage.clear();
      return const Success(null);
    } on ApiException catch (error) {
      return Failure(_failureFrom(error));
    }
  }

  @override
  Future<void> clearLocalSession() => _storage.clear();

  UserSession _sessionFromProfile(
    Map<String, dynamic> json, {
    bool mustChangePassword = false,
  }) {
    final data = json['data'] as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;
    final tenant = data['tenant'] as Map<String, dynamic>;
    final meta = json['meta'] as Map<String, dynamic>;
    return UserSession(
      userId: user['id'] as String,
      userName: user['name'] as String,
      email: user['email'] as String? ?? '',
      tenantId: tenant['id'] as String,
      tenantName: tenant['name'] as String,
      tenantSlug: tenant['slug'] as String,
      features: Set<String>.from(data['features'] as List? ?? const []),
      permissions: {
        for (final entry in (data['permissions'] as Map? ?? const {}).entries)
          entry.key.toString(): entry.value == true,
      },
      revision: meta['revision'] as String? ?? '',
      mustChangePassword:
          mustChangePassword || user['must_change_password'] == true,
    );
  }

  AuthFailure _failureFrom(ApiException error) {
    final code = switch (error) {
      InvalidParamsException(:final code) => code,
      ForbiddenException(:final code) => code,
      _ => null,
    };
    final kind = switch (code) {
      'invalid_credentials' => AuthFailureKind.invalidCredentials,
      'account_inactive' => AuthFailureKind.accountInactive,
      'tenant_inactive' => AuthFailureKind.tenantInactive,
      'password_change_required' => AuthFailureKind.passwordChangeRequired,
      'invalid_current_password' => AuthFailureKind.invalidCurrentPassword,
      _ when error is UnauthorizedException => AuthFailureKind.unauthorized,
      _
          when error is NoInternetException ||
              error is ConnectionTimeoutException ||
              error is RequestCancelledException =>
        AuthFailureKind.unavailable,
      _ when error is RateLimitException => AuthFailureKind.rateLimited,
      _ when error is InvalidParamsException => AuthFailureKind.validation,
      _ when error is ForbiddenException => AuthFailureKind.forbidden,
      _ => AuthFailureKind.unknown,
    };
    return AuthFailure(
      kind,
      error.message,
      code: code,
      fieldErrors: error is InvalidParamsException
          ? {
              for (final entry in error.errors.entries)
                entry.key: entry.value.toString(),
            }
          : const {},
    );
  }
}
