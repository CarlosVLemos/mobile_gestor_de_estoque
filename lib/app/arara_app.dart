import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization/app_strings.dart';
import 'context_sync_scope.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_mode_controller.dart';
import '../core/config/app_mode.dart';
import '../shared/widgets/demo_mode_banner.dart';

class AraraApp extends ConsumerWidget {
  const AraraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final isDemo = ref.watch(appModeProvider).isDemo;
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        final content = ContextSyncScope(child: child ?? const SizedBox.shrink());
        if (!isDemo) return content;
        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              const DemoModeBanner(),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}
