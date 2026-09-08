import '../../../../core/result/result.dart';
import '../entities/auth_failure.dart';
import '../entities/user_session.dart';

abstract class AuthRepository {
  Future<Result<UserSession, AuthFailure>> login({
    required String accessCode,
    required String password,
    required String deviceName,
  });
  Future<Result<UserSession, AuthFailure>> restoreSession();
  Future<Result<void, AuthFailure>> changePassword({
    required String currentPassword,
    required String password,
    required String confirmation,
  });
  Future<Result<void, AuthFailure>> logout();
  Future<void> clearLocalSession();
}
