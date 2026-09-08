import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/arara_app.dart';
import 'package:gestor_de_estoque/core/result/result.dart';
import 'package:gestor_de_estoque/features/auth/auth_providers.dart';
import 'package:gestor_de_estoque/features/auth/domain/entities/auth_failure.dart';
import 'package:gestor_de_estoque/features/auth/domain/entities/user_session.dart';
import 'package:gestor_de_estoque/features/auth/domain/repositories/auth_repository.dart';
import 'package:gestor_de_estoque/shared/widgets/app_bottom_navigation.dart';

void main() {
  testWidgets('sem token redireciona para login', (tester) async {
    await tester.pumpWidget(_app(_FakeAuthRepository()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Código de acesso'), findsOneWidget);
  });

  testWidgets('sessão autenticada entra na shell', (tester) async {
    await tester.pumpWidget(_app(_FakeAuthRepository(session: _session())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(AppBottomNavigation), findsOneWidget);
  });

  testWidgets('troca obrigatória bloqueia shell', (tester) async {
    await tester.pumpWidget(
      _app(_FakeAuthRepository(session: _session(mustChangePassword: true))),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Atualize sua senha'), findsOneWidget);
    expect(find.byType(AppBottomNavigation), findsNothing);
  });
}

Widget _app(AuthRepository repository) => ProviderScope(
  overrides: [authRepositoryProvider.overrideWithValue(repository)],
  child: const AraraApp(),
);

UserSession _session({bool mustChangePassword = false}) => UserSession(
  userId: 'user',
  userName: 'Maria',
  email: 'maria@test.dev',
  tenantId: 'tenant',
  tenantName: 'Empresa',
  tenantSlug: 'empresa',
  features: const {'catalog'},
  permissions: const {'products_view': true},
  revision: 'profile_1',
  mustChangePassword: mustChangePassword,
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.session});
  final UserSession? session;
  @override
  Future<Result<UserSession, AuthFailure>> login({
    required String accessCode,
    required String password,
    required String deviceName,
  }) async => session == null
      ? const Failure(
          AuthFailure(
            AuthFailureKind.invalidCredentials,
            'Credenciais inválidas.',
          ),
        )
      : Success(session!);
  @override
  Future<Result<UserSession, AuthFailure>> restoreSession() async =>
      session == null
      ? const Failure(
          AuthFailure(AuthFailureKind.unauthorized, 'Sessão ausente.'),
        )
      : Success(session!);
  @override
  Future<Result<void, AuthFailure>> changePassword({
    required String currentPassword,
    required String password,
    required String confirmation,
  }) async => const Success(null);
  @override
  Future<Result<void, AuthFailure>> logout() async => const Success(null);
  @override
  Future<void> clearLocalSession() async {}
}
