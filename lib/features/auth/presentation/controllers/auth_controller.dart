import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/session_invalidation_signal.dart';
import '../../../../core/result/result.dart';
import '../../auth_providers.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_session.dart';
import '../state/auth_state.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final signal = ref.watch(sessionInvalidationSignalProvider);
    signal.addListener(_onInvalidSession);
    ref.onDispose(() => signal.removeListener(_onInvalidSession));
    Future<void>.microtask(restore);
    return const AuthState.initializing();
  }

  Future<void> restore() async {
    state = const AuthState(status: AuthStatus.resolvingSession);
    final result = await ref.read(restoreSessionUseCaseProvider).call();
    _applySessionResult(result);
  }

  Future<void> login({
    required String accessCode,
    required String password,
    required String deviceName,
  }) async {
    state = const AuthState(status: AuthStatus.resolvingSession);
    final result = await ref
        .read(loginUseCaseProvider)
        .call(
          accessCode: accessCode.trim(),
          password: password,
          deviceName: deviceName.trim(),
        );
    _applySessionResult(result);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String confirmation,
  }) async {
    final session = state.session;
    state = AuthState(status: AuthStatus.resolvingSession, session: session);
    final result = await ref
        .read(changePasswordUseCaseProvider)
        .call(
          currentPassword: currentPassword,
          password: password,
          confirmation: confirmation,
        );
    switch (result) {
      case Success<void, AuthFailure>():
        await restore();
      case Failure<void, AuthFailure>(:final error):
        state = AuthState(
          status: _operationalStatus(session),
          session: session,
          failure: error,
        );
    }
  }

  Future<void> logout() async {
    final session = state.session;
    final result = await ref.read(logoutUseCaseProvider).call();
    switch (result) {
      case Success<void, AuthFailure>():
        state = const AuthState(status: AuthStatus.unauthenticated);
      case Failure<void, AuthFailure>(:final error):
        state = AuthState(
          status: _operationalStatus(session),
          session: session,
          failure: error,
        );
    }
  }

  Future<void> _onInvalidSession() async {
    await ref.read(invalidateSessionUseCaseProvider).call();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void _applySessionResult(Result<UserSession, AuthFailure> result) {
    switch (result) {
      case Success<UserSession, AuthFailure>(:final value):
        state = AuthState(
          status: value.mustChangePassword
              ? AuthStatus.passwordChangeRequired
              : AuthStatus.authenticated,
          session: value,
        );
      case Failure<UserSession, AuthFailure>(:final error)
          when error.kind == AuthFailureKind.unauthorized:
        state = const AuthState(status: AuthStatus.unauthenticated);
      case Failure<UserSession, AuthFailure>(:final error):
        state = AuthState(
          status: error.kind == AuthFailureKind.unavailable
              ? AuthStatus.unavailable
              : AuthStatus.failure,
          failure: error,
        );
    }
  }

  AuthStatus _operationalStatus(UserSession? session) =>
      session?.mustChangePassword == true
      ? AuthStatus.passwordChangeRequired
      : AuthStatus.authenticated;
}
