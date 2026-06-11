import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  const AppShadows._();

  static List<BoxShadow> card(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.16),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.foreground.withValues(alpha: 0.06),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> hero(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.26),
          blurRadius: 30,
          offset: const Offset(0, 14),
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.foreground.withValues(alpha: 0.12),
        blurRadius: 36,
        offset: const Offset(0, 18),
      ),
    ];
  }

  static List<BoxShadow> floating(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.28),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.foreground.withValues(alpha: 0.14),
        blurRadius: 34,
        offset: const Offset(0, 16),
      ),
    ];
  }
}
