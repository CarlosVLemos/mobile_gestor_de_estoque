import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/result/result.dart';
import 'package:gestor_de_estoque/features/auth/auth_providers.dart';
import 'package:gestor_de_estoque/features/auth/domain/entities/auth_failure.dart';
import 'package:gestor_de_estoque/features/auth/domain/entities/user_session.dart';
import 'package:gestor_de_estoque/features/auth/domain/repositories/auth_repository.dart';
import 'package:gestor_de_estoque/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gestor_de_estoque/features/auth/presentation/state/auth_state.dart';

void main() {
  test('erro ao trocar senha preserva rota obrigatória', () async {
    final repo = _Repo(
      session: _session(),
      passwordResult: const Failure(
        AuthFailure(
          AuthFailureKind.invalidCurrentPassword,
          'Senha atual inválida.',
        ),
      ),
    );
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    final controller = container.read(authControllerProvider.notifier);
    await controller.restore();
    await controller.changePassword(
      currentPassword: 'x',
      password: 'nova',
      confirmation: 'nova',
    );
    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.passwordChangeRequired);
    expect(state.failure?.kind, AuthFailureKind.invalidCurrentPassword);
  });

  test('401 limpa sessão por use case', () async {
    final repo = _Repo(session: _session());
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    container.read(authControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await container.read(authControllerProvider.notifier).logout();
    expect(
      container.read(authControllerProvider).status,
      AuthStatus.unauthenticated,
    );
    expect(repo.logoutCalled, isTrue);
  });
}

UserSession _session() => const UserSession(
  userId: 'u',
  userName: 'Maria',
  email: 'm@test',
  tenantId: 't',
  tenantName: 'Empresa',
  tenantSlug: 'empresa',
  features: {'catalog'},
  permissions: {'products_view': true},
  revision: 'r',
  mustChangePassword: true,
);

class _Repo implements AuthRepository {
  _Repo({required this.session, this.passwordResult});
  final UserSession session;
  final Result<void, AuthFailure>? passwordResult;
  bool logoutCalled = false;
  @override
  Future<Result<UserSession, AuthFailure>> login({
    required String accessCode,
    required String password,
    required String deviceName,
  }) async => Success(session);
  @override
  Future<Result<UserSession, AuthFailure>> restoreSession() async =>
      Success(session);
  @override
  Future<Result<void, AuthFailure>> changePassword({
    required String currentPassword,
    required String password,
    required String confirmation,
  }) async => passwordResult ?? const Success(null);
  @override
  Future<Result<void, AuthFailure>> logout() async {
    logoutCalled = true;
    return const Success(null);
  }

  @override
  Future<void> clearLocalSession() async {}
}
