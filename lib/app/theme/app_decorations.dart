import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';
import 'app_theme_context.dart';

enum AppStatusTone { success, warning, error, restricted }

abstract final class AppDecorations {
  const AppDecorations._();

  static BoxDecoration atmosphericBackground(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appColors;

    return BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      gradient: tokens.atmosphericGradient,
    );
  }

  static BoxDecoration card(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final tokens = context.appColors;

    return BoxDecoration(
      color: colors.surfaceContainerLow,
      borderRadius: AppRadius.heroBorder,
      border: Border.all(color: tokens.borderSubtle),
      boxShadow: AppShadows.card(theme.brightness),
    );
  }

  static BoxDecoration elevatedCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final tokens = context.appColors;

    return BoxDecoration(
      color: colors.surfaceContainer,
      borderRadius: AppRadius.heroBorder,
      border: Border.all(color: tokens.borderSubtle),
      boxShadow: AppShadows.floating(theme.brightness),
    );
  }

  static BoxDecoration hero(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appColors;

    return BoxDecoration(
      color: tokens.surfaceHero,
      borderRadius: AppRadius.heroBorder,
      border: Border.all(color: tokens.borderSubtle),
      gradient: tokens.heroGradient,
      boxShadow: AppShadows.hero(theme.brightness),
    );
  }

  static BoxDecoration floatingSurface(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final tokens = context.appColors;

    return BoxDecoration(
      color: colors.surfaceContainerHigh,
      borderRadius: AppRadius.xlBorder,
      border: Border.all(color: tokens.borderSubtle),
      boxShadow: AppShadows.floating(theme.brightness),
    );
  }

  static BoxDecoration glassSurface(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return BoxDecoration(
      color: colors.surface.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.72 : 0.88,
      ),
      borderRadius: AppRadius.heroBorder,
      border: Border.all(
        color: theme.brightness == Brightness.dark
            ? colors.onSurface.withValues(alpha: 0.08)
            : AppColors.white.withValues(alpha: 0.72),
      ),
      boxShadow: AppShadows.floating(theme.brightness),
    );
  }

  /// Variante de vidro sem borderRadius, para uso em barras de navegação
  /// que são recortadas pelo container pai com [ClipRRect].
  static BoxDecoration glassSurfaceBar(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return BoxDecoration(
      color: colors.surface.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.72 : 0.88,
      ),
      border: Border(
        top: BorderSide(
          color: theme.brightness == Brightness.dark
              ? colors.onSurface.withValues(alpha: 0.08)
              : AppColors.white.withValues(alpha: 0.72),
        ),
      ),
    );
  }

  static BoxDecoration tonalBadge(BuildContext context, AppStatusTone tone) {
    final colors = context.colors;
    final tokens = context.appColors;

    final (background, foreground) = switch (tone) {
      AppStatusTone.success => (
        tokens.successContainer,
        tokens.onSuccessContainer,
      ),
      AppStatusTone.warning => (
        tokens.warningContainer,
        tokens.onWarningContainer,
      ),
      AppStatusTone.error => (colors.errorContainer, colors.onErrorContainer),
      AppStatusTone.restricted => (tokens.restricted, tokens.onRestricted),
    };

    return BoxDecoration(
      color: background,
      borderRadius: AppRadius.pill,
      border: Border.all(color: foreground.withValues(alpha: 0.18)),
    );
  }
}
