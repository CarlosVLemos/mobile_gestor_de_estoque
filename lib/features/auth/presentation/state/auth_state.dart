import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_session.dart';

enum AuthStatus {
  initializing,
  unauthenticated,
  resolvingSession,
  authenticated,
  passwordChangeRequired,
  unavailable,
  failure,
}

class AuthState {
  const AuthState({required this.status, this.session, this.failure});
  const AuthState.initializing() : this(status: AuthStatus.initializing);
  final AuthStatus status;
  final UserSession? session;
  final AuthFailure? failure;
}

class LogoutAttempt {
  const LogoutAttempt._({this.pendingOutboxCount = 0, this.failure});

  const LogoutAttempt.completed() : this._();
  const LogoutAttempt.pendingOutbox(int count)
    : this._(pendingOutboxCount: count);
  const LogoutAttempt.failed(AuthFailure value) : this._(failure: value);

  final int pendingOutboxCount;
  final AuthFailure? failure;

  bool get requiresConfirmation => pendingOutboxCount > 0;
  bool get succeeded => !requiresConfirmation && failure == null;
}
