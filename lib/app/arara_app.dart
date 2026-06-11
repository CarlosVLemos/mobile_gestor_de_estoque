import 'package:flutter/material.dart';

import 'localization/app_strings.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class AraraApp extends StatelessWidget {
  const AraraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
