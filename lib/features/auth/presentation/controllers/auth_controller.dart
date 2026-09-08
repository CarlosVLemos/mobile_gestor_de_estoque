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
    _applySessionResult(result, isRestore: true);
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
    state = AuthState(
      status: AuthStatus.resolvingSession,
      session: state.session,
    );
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
          status: error.kind == AuthFailureKind.unavailable
              ? AuthStatus.unavailable
              : AuthStatus.failure,
          session: state.session,
          failure: error,
        );
    }
  }

  Future<void> logout() async {
    final result = await ref.read(authRepositoryProvider).logout();
    switch (result) {
      case Success<void, AuthFailure>():
        state = const AuthState(status: AuthStatus.unauthenticated);
      case Failure<void, AuthFailure>(:final error):
        state = AuthState(
          status: error.kind == AuthFailureKind.unavailable
              ? AuthStatus.unavailable
              : AuthStatus.failure,
          session: state.session,
          failure: error,
        );
    }
  }

  Future<void> _onInvalidSession() async {
    await ref.read(authRepositoryProvider).clearLocalSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void _applySessionResult(
    Result<UserSession, AuthFailure> result, {
    bool isRestore = false,
  }) {
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
}
