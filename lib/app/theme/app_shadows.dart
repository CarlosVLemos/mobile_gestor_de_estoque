import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  const AppShadows._();

  static List<BoxShadow> card(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.12),
          blurRadius: 28,
          spreadRadius: 1,
          offset: const Offset(0, 6),
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.foreground.withValues(alpha: 0.04),
        blurRadius: 28,
        spreadRadius: 1,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static List<BoxShadow> hero(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.22),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.foreground.withValues(alpha: 0.10),
        blurRadius: 36,
        offset: const Offset(0, 12),
      ),
    ];
  }

  static List<BoxShadow> floating(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.22),
          blurRadius: 40,
          offset: const Offset(0, 14),
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.foreground.withValues(alpha: 0.10),
        blurRadius: 40,
        offset: const Offset(0, 14),
        spreadRadius: 1,
      ),
    ];
  }
}
