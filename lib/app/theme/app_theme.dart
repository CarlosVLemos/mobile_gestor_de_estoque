import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.surface,
      outline: AppColors.border,
    ),
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.border,
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      bodyLarge: TextStyle(color: AppColors.textPrimary, height: 1.5),
      labelMedium: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    ),
  );
}
