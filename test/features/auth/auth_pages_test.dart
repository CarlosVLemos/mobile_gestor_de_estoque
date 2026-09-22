import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/startup/startup_page.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/auth/domain/entities/auth_failure.dart';
import 'package:gestor_de_estoque/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gestor_de_estoque/features/auth/presentation/pages/change_password_page.dart';
import 'package:gestor_de_estoque/features/auth/presentation/pages/login_page.dart';
import 'package:gestor_de_estoque/features/auth/presentation/state/auth_state.dart';

void main() {
  setUp(_TestAuthController.reset);

  testWidgets('startup apresenta restauração e permite tentar novamente', (
    tester,
  ) async {
    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.resolvingSession,
    );
    await tester.pumpWidget(_page(const StartupPage()));
    expect(find.text('Preparando seu ambiente'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.unavailable,
      failure: AuthFailure(AuthFailureKind.unavailable, 'Sem conexão.'),
    );
    await tester.pumpWidget(_page(const StartupPage()));
    expect(find.text('Não foi possível validar sua sessão'), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    expect(_TestAuthController.restoreCalls, 1);
  });

  testWidgets('login preserva credenciais, valida obrigatórios e exibe erro', (
    tester,
  ) async {
    await tester.pumpWidget(_page(const LoginPage()));
    expect(find.text('Bem-vindo'), findsOneWidget);
    await tester.ensureVisible(find.text('Entrar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    expect(find.text('Informe Código de acesso.'), findsOneWidget);
    expect(find.text('Informe Senha.'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), ' AC-101 ');
    await tester.enterText(fields.at(1), 'segredo');
    await tester.enterText(fields.at(2), 'Coletor Norte');
    await tester.tap(find.text('Entrar'));
    expect(_TestAuthController.loginCall, (' AC-101 ', 'segredo', 'Coletor Norte'));

    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.unauthenticated,
      failure: AuthFailure(AuthFailureKind.unauthorized, 'Acesso não autorizado.'),
    );
    await tester.pumpWidget(_page(const LoginPage()));
    expect(find.text('Acesso não autorizado.'), findsOneWidget);
  });

  testWidgets('login bloqueia submit em busy e alterna visibilidade da senha', (
    tester,
  ) async {
    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.resolvingSession,
    );
    await tester.pumpWidget(_page(const LoginPage()));
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);

    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.unauthenticated,
    );
    await tester.pumpWidget(_page(const LoginPage()));
    expect(_obscureTextOf(tester, find.byKey(loginPasswordFieldKey)), isTrue);
    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pump();
    expect(_obscureTextOf(tester, find.byKey(loginPasswordFieldKey)), isFalse);
  });

  testWidgets('login compacto mantém CTA alcançável durante scroll', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(
      _page(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: LoginPage(),
        ),
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Entrar'),
      100,
      scrollable: _authScrollableFor(find.byKey(loginPasswordFieldKey)),
    );
    expect(find.text('Entrar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('troca de senha preserva campos, payload, erro e logout', (
    tester,
  ) async {
    await tester.pumpWidget(_page(const ChangePasswordPage()));
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(3));
    await tester.enterText(fields.at(0), 'atual');
    await tester.enterText(fields.at(1), 'nova');
    await tester.enterText(fields.at(2), 'nova');
    await tester.tap(find.text('Atualizar senha'));
    expect(_TestAuthController.passwordCall, ('atual', 'nova', 'nova'));
    await tester.tap(find.text('Sair da conta'));
    expect(_TestAuthController.logoutCalls, 1);

    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.passwordChangeRequired,
      failure: AuthFailure(AuthFailureKind.invalidCurrentPassword, 'Senha atual inválida.'),
    );
    await tester.pumpWidget(_page(const ChangePasswordPage()));
    expect(find.text('Senha atual inválida.'), findsOneWidget);
  });

  testWidgets('troca de senha bloqueia busy, alterna campos e reflow compacto', (
    tester,
  ) async {
    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.resolvingSession,
    );
    await tester.pumpWidget(_page(const ChangePasswordPage()));
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);

    _TestAuthController.seedState = const AuthState(
      status: AuthStatus.passwordChangeRequired,
    );
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _page(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: ChangePasswordPage(),
        ),
      ),
    );
    await tester.ensureVisible(find.byTooltip('Mostrar Senha atual'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mostrar Senha atual'));
    await tester.pump();
    await tester.ensureVisible(find.byTooltip('Mostrar Nova senha'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mostrar Nova senha'));
    await tester.pump();
    await tester.ensureVisible(find.byTooltip('Mostrar Confirme a nova senha'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mostrar Confirme a nova senha'));
    await tester.pump();
    expect(
      _obscureTextOf(tester, find.byKey(changePasswordCurrentFieldKey)),
      isFalse,
    );
    expect(
      _obscureTextOf(tester, find.byKey(changePasswordNewFieldKey)),
      isFalse,
    );
    expect(
      _obscureTextOf(
        tester,
        find.byKey(changePasswordConfirmationFieldKey),
      ),
      isFalse,
    );
    await tester.scrollUntilVisible(
      find.text('Sair da conta'),
      100,
      scrollable: _authScrollableFor(find.byKey(changePasswordCurrentFieldKey)),
    );
    expect(find.text('Sair da conta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _page(Widget child) => ProviderScope(
  key: UniqueKey(),
  overrides: [authControllerProvider.overrideWith(_TestAuthController.new)],
  child: MaterialApp(theme: AppTheme.light, home: child),
);

class _TestAuthController extends AuthController {
  static AuthState seedState = const AuthState(
    status: AuthStatus.unauthenticated,
  );
  static (String, String, String)? loginCall;
  static (String, String, String)? passwordCall;
  static int restoreCalls = 0;
  static int logoutCalls = 0;

  static void reset() {
    seedState = const AuthState(status: AuthStatus.unauthenticated);
    loginCall = null;
    passwordCall = null;
    restoreCalls = 0;
    logoutCalls = 0;
  }

  @override
  AuthState build() => seedState;

  @override
  Future<void> restore() async {
    restoreCalls += 1;
  }

  @override
  Future<void> login({
    required String accessCode,
    required String password,
    required String deviceName,
  }) async {
    loginCall = (accessCode, password, deviceName);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String confirmation,
  }) async {
    passwordCall = (currentPassword, password, confirmation);
  }

  @override
  Future<LogoutAttempt> logout({bool confirmPendingOutbox = false}) async {
    logoutCalls += 1;
    return const LogoutAttempt.completed();
  }
}

bool _obscureTextOf(WidgetTester tester, Finder field) => tester
    .widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    )
    .obscureText;

Finder _authScrollableFor(Finder field) => find.ancestor(
  of: field,
  matching: find.byType(Scrollable),
);
