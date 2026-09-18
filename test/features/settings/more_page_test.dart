import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/router/app_routes.dart';
import 'package:gestor_de_estoque/app/session_actions.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/app/theme/app_icons.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/app/theme/app_theme_mode_controller.dart';
import 'package:gestor_de_estoque/features/auth/presentation/state/auth_state.dart';
import 'package:gestor_de_estoque/features/settings/presentation/pages/more_page.dart';
import 'package:gestor_de_estoque/shared/widgets/operational_top_bar.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('mostra somente capacidades reais e identidade disponível', (
    tester,
  ) async {
    final container = _container();
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));

    expect(find.text('Maria Campo'), findsOneWidget);
    expect(find.text('Arara Equipamentos'), findsOneWidget);
    expect(find.text('Conta e empresa'), findsOneWidget);
    expect(find.text('Aparência'), findsOneWidget);
    expect(find.text('Sair'), findsOneWidget);
    expect(find.text('Estoque'), findsNothing);
    expect(find.text('Relatórios'), findsNothing);
    expect(find.text('Alterar nome'), findsNothing);
    expect(find.textContaining('fora do escopo'), findsNothing);
    expect(find.textContaining('Aguardando endpoint'), findsNothing);

    final topBar = find.byType(OperationalTopBar);
    expect(
      find.descendant(of: topBar, matching: find.byIcon(AppIcons.menu)),
      findsNothing,
    );
    expect(
      find.descendant(of: topBar, matching: find.byIcon(AppIcons.search)),
      findsNothing,
    );
    expect(
      find.descendant(of: topBar, matching: find.byIcon(AppIcons.themeDark)),
      findsNothing,
    );
    expect(
      find.descendant(of: topBar, matching: find.byIcon(AppIcons.themeLight)),
      findsNothing,
    );
  });

  testWidgets('navega para a rota existente de Conta e empresa', (
    tester,
  ) async {
    final container = _container();
    final router = GoRouter(
      initialLocation: AppRoutes.more,
      routes: [
        GoRoute(
          path: AppRoutes.more,
          builder: (_, _) => const MorePage(),
        ),
        GoRoute(
          path: AppRoutes.context,
          builder: (_, _) => const Scaffold(body: Text('Conta aberta')),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(router.dispose);

    await tester.pumpWidget(_routerApp(container, router));
    await tester.tap(find.text('Conta e empresa'));
    await tester.pumpAndSettle();

    expect(find.text('Conta aberta'), findsOneWidget);
  });

  testWidgets('seleciona Sistema, Claro e Escuro no controller existente', (
    tester,
  ) async {
    final container = _container();
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));

    expect(container.read(appThemeModeProvider), ThemeMode.system);
    await tester.tap(find.text('Claro'));
    await tester.pump();
    expect(container.read(appThemeModeProvider), ThemeMode.light);

    await tester.tap(find.text('Escuro'));
    await tester.pump();
    expect(container.read(appThemeModeProvider), ThemeMode.dark);

    await tester.tap(find.text('Sistema'));
    await tester.pump();
    expect(container.read(appThemeModeProvider), ThemeMode.system);
  });

  testWidgets('logout simples usa o fluxo existente uma vez', (tester) async {
    final calls = <bool>[];
    final container = _container(
      logout: ({bool confirmPendingOutbox = false}) async {
        calls.add(confirmPendingOutbox);
        return const LogoutAttempt.completed();
      },
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));
    await tester.tap(find.text('Sair'));
    await tester.pump();

    expect(calls, [false]);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('cancelar logout com pendências preserva a sessão', (
    tester,
  ) async {
    final calls = <bool>[];
    final container = _container(
      logout: ({bool confirmPendingOutbox = false}) async {
        calls.add(confirmPendingOutbox);
        return const LogoutAttempt.pendingOutbox(2);
      },
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();

    expect(find.text('Existem operações pendentes'), findsOneWidget);
    expect(find.textContaining('2 operações'), findsOneWidget);
    expect(find.textContaining('outbox'), findsNothing);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(calls, [false]);
  });

  testWidgets('confirmar logout repassa confirmação ao fluxo existente', (
    tester,
  ) async {
    final calls = <bool>[];
    final container = _container(
      logout: ({bool confirmPendingOutbox = false}) async {
        calls.add(confirmPendingOutbox);
        return confirmPendingOutbox
            ? const LogoutAttempt.completed()
            : const LogoutAttempt.pendingOutbox(1);
      },
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_app(container));
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair mesmo assim'));
    await tester.pumpAndSettle();

    expect(calls, [false, true]);
  });

  testWidgets('permanece rolável em 320px com text scaler 2.0', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = _container();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(
        container,
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: MorePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Sair'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sair'), findsOneWidget);
  });
}

ProviderContainer _container({
  Future<LogoutAttempt> Function({bool confirmPendingOutbox})? logout,
}) {
  return ProviderContainer(
    overrides: [
      shellProfileProvider.overrideWithValue(_profile()),
      sessionActionsProvider.overrideWithValue(
        SessionActions(
          logout ??
              ({bool confirmPendingOutbox = false}) async =>
                  const LogoutAttempt.completed(),
        ),
      ),
    ],
  );
}

Widget _app(
  ProviderContainer container, {
  Widget home = const MorePage(),
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: home,
    ),
  );
}

Widget _routerApp(ProviderContainer container, GoRouter router) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    ),
  );
}

ShellProfile _profile() => ShellProfile(
  userName: 'Maria Campo',
  userEmail: 'maria@example.test',
  tenantName: 'Arara Equipamentos',
  tenantSlug: 'arara',
  features: const {'catalog', 'sales'},
  permissions: const {'products_view': true, 'sales_create': true},
);
