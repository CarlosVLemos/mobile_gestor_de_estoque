import 'package:go_router/go_router.dart';

import '../startup/startup_page.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.startup,
  routes: [
    GoRoute(
      path: AppRoutes.startup,
      builder: (context, state) => const StartupPage(),
    ),
  ],
);
