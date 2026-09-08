import '../../../../core/result/result.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;
  Future<Result<UserSession, AuthFailure>> call({
    required String accessCode,
    required String password,
    required String deviceName,
  }) => _repository.login(
    accessCode: accessCode,
    password: password,
    deviceName: deviceName,
  );
}

class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);
  final AuthRepository _repository;
  Future<Result<UserSession, AuthFailure>> call() =>
      _repository.restoreSession();
}

class ChangePasswordUseCase {
  const ChangePasswordUseCase(this._repository);
  final AuthRepository _repository;
  Future<Result<void, AuthFailure>> call({
    required String currentPassword,
    required String password,
    required String confirmation,
  }) => _repository.changePassword(
    currentPassword: currentPassword,
    password: password,
    confirmation: confirmation,
  );
}
