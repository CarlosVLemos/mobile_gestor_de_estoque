import 'package:flutter/material.dart';

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

  static BoxDecoration tonalBadge(
    BuildContext context,
    AppStatusTone tone,
  ) {
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
      AppStatusTone.error => (
        colors.errorContainer,
        colors.onErrorContainer,
      ),
      AppStatusTone.restricted => (tokens.restricted, tokens.onRestricted),
    };

    return BoxDecoration(
      color: background,
      borderRadius: AppRadius.pill,
      border: Border.all(color: foreground.withValues(alpha: 0.18)),
    );
  }
}
