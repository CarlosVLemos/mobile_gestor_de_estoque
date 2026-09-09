import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/local_context_lifecycle.dart';
import '../../../../core/database/local_context.dart';
import '../../../../core/network/session_invalidation_signal.dart';
import '../../../../core/result/result.dart';
import '../../../../core/sync/sync_state.dart';
import '../../auth_providers.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_session.dart';
import '../state/auth_state.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  Future<void>? _sessionTerminationInFlight;
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
    await _applySessionResult(result);
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
    await _applySessionResult(result);
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

  Future<LogoutAttempt> logout({bool confirmPendingOutbox = false}) async {
    final session = state.session;
    final purgeService = ref.read(dataPurgeServiceProvider);
    final pendingOutboxCount = await purgeService.pendingOutboxCount();
    if (pendingOutboxCount > 0 && !confirmPendingOutbox) {
      return LogoutAttempt.pendingOutbox(pendingOutboxCount);
    }

    state = AuthState(status: AuthStatus.resolvingSession, session: session);
    final result = await ref.read(logoutUseCaseProvider).call();
    switch (result) {
      case Success<void, AuthFailure>():
        await _transitionToUnauthenticated();
        return const LogoutAttempt.completed();
      case Failure<void, AuthFailure>(:final error):
        state = AuthState(
          status: _operationalStatus(session),
          session: session,
          failure: error,
        );
        return LogoutAttempt.failed(error);
    }
  }

  Future<void> _onInvalidSession() async {
    await ref.read(invalidateSessionUseCaseProvider).call();
    await _transitionToUnauthenticated();
  }

  Future<void> _applySessionResult(
    Result<UserSession, AuthFailure> result,
  ) async {
    switch (result) {
      case Success<UserSession, AuthFailure>(:final value):
        try {
          await ref
              .read(databaseFactoryProvider)
              .open(
                LocalContext(userId: value.userId, tenantId: value.tenantId),
              );
          ref.invalidate(operationalDatabaseProvider);
          final engine = ref.read(contextSyncEngineProvider);
          if (engine != null) unawaited(engine.sync(trigger: SyncTrigger.startup));
          state = AuthState(
            status: value.mustChangePassword
                ? AuthStatus.passwordChangeRequired
                : AuthStatus.authenticated,
            session: value,
          );
        } catch (_) {
          state = const AuthState(
            status: AuthStatus.failure,
            failure: AuthFailure(
              AuthFailureKind.unknown,
              'Não foi possível abrir os dados locais deste contexto.',
            ),
          );
        }
      case Failure<UserSession, AuthFailure>(:final error)
          when error.kind == AuthFailureKind.unauthorized:
        await _transitionToUnauthenticated();
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

  Future<void> _transitionToUnauthenticated() {
    final inFlight = _sessionTerminationInFlight;
    if (inFlight != null) return inFlight;

    late final Future<void> operation;
    operation = _completeSessionTermination().whenComplete(() {
      if (identical(_sessionTerminationInFlight, operation)) {
        _sessionTerminationInFlight = null;
      }
    });
    _sessionTerminationInFlight = operation;
    return operation;
  }

  Future<void> _completeSessionTermination() async {
    await ref.read(dataPurgeServiceProvider).purge();
    if (!ref.mounted) return;
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
