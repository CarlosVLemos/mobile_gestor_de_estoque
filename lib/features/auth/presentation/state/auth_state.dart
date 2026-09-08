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
