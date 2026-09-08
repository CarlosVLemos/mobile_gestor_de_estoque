import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/state/auth_state.dart';

import '../../features/catalog/presentation/pages/catalog_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/sales/presentation/pages/sales_page.dart';
import '../../features/settings/presentation/pages/more_page.dart';
import '../../features/settings/presentation/pages/operational_context_page.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../../shared/widgets/app_shell_scaffold.dart';
import '../localization/app_strings.dart';
import '../startup/startup_page.dart';
import '../theme/app_icons.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final auth = ref.watch(authControllerProvider);
  final refresh = ref.watch(_authRouterRefreshProvider);
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.startup,
    refreshListenable: refresh,
    redirect: (context, routeState) {
      final location = routeState.matchedLocation;
      final isPublic =
          location == AppRoutes.startup || location == AppRoutes.login;
      final isPasswordRoute = location == AppRoutes.changePassword;
      if (auth.status == AuthStatus.initializing ||
          auth.status == AuthStatus.resolvingSession) {
        return isPublic ? null : AppRoutes.startup;
      }
      if (auth.status == AuthStatus.unauthenticated) {
        return location == AppRoutes.login ? null : AppRoutes.login;
      }
      if (auth.status == AuthStatus.passwordChangeRequired) {
        return isPasswordRoute ? null : AppRoutes.changePassword;
      }
      if (auth.status == AuthStatus.authenticated) {
        return (isPublic || isPasswordRoute) ? AppRoutes.dashboard : null;
      }
      return isPublic ? null : AppRoutes.login;
    },
    routes: [
      GoRoute(
        path: AppRoutes.startup,
        builder: (context, state) => const StartupPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      // TODO(auth): proteger a shell operacional quando o fluxo mobile de login
      // estiver disponível. Até lá, esta navegação usa bootstrap local controlado.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _OperationalShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.products,
                builder: (context, state) => const CatalogPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sales,
                builder: (context, state) => const SalesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (context, state) => const MorePage(),
              ),
              // TODO(auth): a rota permanece pública apenas dentro do bootstrap
              // local enquanto a spec de autenticação não existe.
              GoRoute(
                path: AppRoutes.context,
                builder: (context, state) => const OperationalContextPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});

final _authRouterRefreshProvider = Provider<_AuthRouterRefresh>((ref) {
  final refresh = _AuthRouterRefresh();
  ref.listen(authControllerProvider, (_, _) => refresh.refresh());
  ref.onDispose(refresh.dispose);
  return refresh;
});

class _AuthRouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

class _OperationalShellPage extends StatelessWidget {
  const _OperationalShellPage({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AppShellScaffold(
      body: navigationShell,
      currentIndex: navigationShell.currentIndex,
      destinations: const [
        AppBottomNavigationDestination(
          label: AppStrings.shellDashboard,
          icon: AppIcons.dashboard,
        ),
        AppBottomNavigationDestination(
          label: AppStrings.shellProducts,
          icon: AppIcons.products,
        ),
        AppBottomNavigationDestination(
          label: AppStrings.shellSales,
          icon: AppIcons.sales,
        ),
        AppBottomNavigationDestination(
          label: AppStrings.shellMore,
          icon: AppIcons.more,
        ),
      ],
      onSelect: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
    );
  }
}
