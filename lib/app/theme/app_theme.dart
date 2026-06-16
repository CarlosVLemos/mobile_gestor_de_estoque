import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildTheme(
    colorScheme: _lightColorScheme,
    tokens: _lightTokens,
    scaffoldBackgroundColor: AppColors.background,
  );

  static ThemeData get dark => _buildTheme(
    colorScheme: _darkColorScheme,
    tokens: _darkTokens,
    scaffoldBackgroundColor: AppColors.backgroundDark,
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required AppColorTokens tokens,
    required Color scaffoldBackgroundColor,
  }) {
    final textTheme = AppTypography.build(colorScheme);
    final isDark = colorScheme.brightness == Brightness.dark;
    final disabledForeground = colorScheme.onSurface.withValues(
      alpha: isDark ? 0.38 : 0.34,
    );
    final disabledBackground = colorScheme.onSurface.withValues(
      alpha: isDark ? 0.12 : 0.08,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      visualDensity: VisualDensity.standard,
      extensions: <ThemeExtension<dynamic>>[tokens],
    );

    final outlineBorder = OutlineInputBorder(
      borderRadius: AppRadius.lgBorder,
      borderSide: BorderSide(color: tokens.borderSubtle),
    );

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        toolbarHeight: AppSizes.appBarHeight,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlBorder,
          side: BorderSide(color: tokens.borderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: tokens.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: AppSpacing.controlPadding,
        constraints: const BoxConstraints(minHeight: AppSizes.inputHeight),
        hintStyle: textTheme.bodyMedium?.copyWith(color: tokens.onSurfaceMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: tokens.onSurfaceMuted,
        ),
        helperStyle: textTheme.bodySmall?.copyWith(
          color: tokens.onSurfaceMuted,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
        prefixIconColor: tokens.onSurfaceMuted,
        suffixIconColor: tokens.onSurfaceMuted,
        enabledBorder: outlineBorder,
        border: outlineBorder,
        focusedBorder: outlineBorder.copyWith(
          borderSide: BorderSide(color: tokens.focusRing, width: 1.4),
        ),
        errorBorder: outlineBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: outlineBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error, width: 1.4),
        ),
        disabledBorder: outlineBorder.copyWith(
          borderSide: BorderSide(
            color: tokens.borderSubtle.withValues(alpha: 0.5),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.buttonHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledBackground;
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledForeground;
            }
            return colorScheme.onPrimary;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.buttonHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: tokens.borderSubtle.withValues(alpha: 0.5),
              );
            }
            return BorderSide(color: tokens.borderSubtle);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledForeground;
            }
            return colorScheme.onSurface;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.surfaceContainerHighest;
            }
            return Colors.transparent;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.buttonHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledForeground;
            }
            return colorScheme.primary;
          }),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size.square(AppSizes.minTouchTarget),
          ),
          maximumSize: const WidgetStatePropertyAll(
            Size.square(AppSizes.minTouchTarget),
          ),
          iconSize: const WidgetStatePropertyAll(AppSizes.actionIcon),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.sm)),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            if (states.contains(WidgetState.disabled)) {
              return disabledForeground;
            }
            return colorScheme.onSurface;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primaryContainer;
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.surfaceContainerHighest;
            }
            return Colors.transparent;
          }),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        iconSize: AppSizes.emphasisIcon,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlBorder),
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(
            showDragHandle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: AppRadius.radiusHero),
            ),
          ).copyWith(
            backgroundColor: colorScheme.surfaceContainerLow,
            surfaceTintColor: Colors.transparent,
            modalBackgroundColor: colorScheme.surfaceContainerLow,
          ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.heroBorder),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLow,
        disabledColor: disabledBackground,
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        labelStyle: textTheme.bodySmall,
        secondaryLabelStyle: textTheme.bodySmall,
        brightness: colorScheme.brightness,
        side: BorderSide(color: tokens.borderSubtle),
        shape: const StadiumBorder(),
        checkmarkColor: colorScheme.onPrimaryContainer,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        circularTrackColor: colorScheme.surfaceContainerHighest,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
      ),
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: AppRadius.mdBorder,
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
    );
  }

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.accent,
    onPrimaryContainer: AppColors.accentForeground,
    secondary: AppColors.secondary,
    onSecondary: AppColors.secondaryForeground,
    secondaryContainer: AppColors.accent,
    onSecondaryContainer: AppColors.secondaryForeground,
    tertiary: AppColors.chart2Light,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.successContainerLight,
    onTertiaryContainer: AppColors.successForegroundLight,
    error: AppColors.danger,
    onError: AppColors.white,
    errorContainer: AppColors.dangerContainerLight,
    onErrorContainer: AppColors.dangerForegroundLight,
    surface: AppColors.surface,
    onSurface: AppColors.foreground,
    onSurfaceVariant: AppColors.mutedForeground,
    outline: AppColors.border,
    outlineVariant: AppColors.border,
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.foreground,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.primary,
    surfaceTint: AppColors.primary,
    surfaceDim: AppColors.secondary,
    surfaceBright: AppColors.surface,
    surfaceContainerLowest: AppColors.surface,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.accent,
    surfaceContainerHigh: AppColors.secondary,
    surfaceContainerHighest: AppColors.muted,
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.surfaceHeroDark,
    primaryContainer: Color(0xFF183D6B),
    onPrimaryContainer: Color(0xFFDCEBFF),
    secondary: Color(0xFFCAD6E5),
    onSecondary: AppColors.surfaceDark,
    secondaryContainer: Color(0xFF15263A),
    onSecondaryContainer: AppColors.foregroundDark,
    tertiary: AppColors.chart2Dark,
    onTertiary: AppColors.surfaceHeroDark,
    tertiaryContainer: AppColors.successContainerDark,
    onTertiaryContainer: AppColors.successForegroundDark,
    error: AppColors.dangerDark,
    onError: AppColors.surfaceHeroDark,
    errorContainer: AppColors.dangerContainerDark,
    onErrorContainer: AppColors.dangerForegroundDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.foregroundDark,
    onSurfaceVariant: AppColors.mutedForegroundDark,
    outline: AppColors.borderDark,
    outlineVariant: Color(0xFF1A2840),
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.surface,
    onInverseSurface: AppColors.foreground,
    inversePrimary: AppColors.primary,
    surfaceTint: AppColors.primaryDark,
    surfaceDim: AppColors.backgroundDark,
    surfaceBright: AppColors.surfaceMutedDark,
    surfaceContainerLowest: AppColors.surfaceDark,
    surfaceContainerLow: Color(0xFF0F1C2E),
    surfaceContainer: AppColors.surfaceMutedDark,
    surfaceContainerHigh: Color(0xFF142338),
    surfaceContainerHighest: Color(0xFF1A2A40),
  );

  static const _lightTokens = AppColorTokens(
    surfaceMuted: AppColors.muted,
    surfaceHero: AppColors.sidebarOperational,
    onSurfaceHero: AppColors.sidebarOperationalForeground,
    onSurfaceMuted: AppColors.mutedForeground,
    success: AppColors.success,
    onSuccess: AppColors.white,
    successContainer: AppColors.successContainerLight,
    onSuccessContainer: AppColors.successForegroundLight,
    warning: AppColors.warning,
    onWarning: AppColors.white,
    warningContainer: AppColors.warningContainerLight,
    onWarningContainer: AppColors.warningForegroundLight,
    restricted: AppColors.restrictedLight,
    onRestricted: AppColors.restrictedForegroundLight,
    borderSubtle: AppColors.border,
    focusRing: AppColors.focusLight,
    sidebarOperational: AppColors.sidebarOperational,
    sidebarOperationalForeground: AppColors.sidebarOperationalForeground,
    sidebarAdmin: AppColors.sidebarAdmin,
    sidebarAdminAccent: AppColors.adminAccent,
    chart1: AppColors.chart1Light,
    chart2: AppColors.chart2Light,
    chart3: AppColors.chart3Light,
    chart4: AppColors.chart4Light,
    chart5: AppColors.chart5Light,
    atmosphericGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFE8F0FE),
        Color(0xFFF3F7FC),
        Color(0xFFF8FAFC),
        Color(0xFFFFFBF0),
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0B1A2B), Color(0xFF143256)],
    ),
    authGradient: RadialGradient(
      center: Alignment.topLeft,
      radius: 1.5,
      colors: [Color(0xFFD9E9FF), Color(0xFFF8FAFC), Color(0xFFFFF1D6)],
      stops: [0.0, 0.62, 1.0],
    ),
  );

  static const _darkTokens = AppColorTokens(
    surfaceMuted: AppColors.surfaceMutedDark,
    surfaceHero: AppColors.surfaceHeroDark,
    onSurfaceHero: AppColors.foregroundDark,
    onSurfaceMuted: AppColors.mutedForegroundDark,
    success: AppColors.successDark,
    onSuccess: AppColors.surfaceHeroDark,
    successContainer: AppColors.successContainerDark,
    onSuccessContainer: AppColors.successForegroundDark,
    warning: AppColors.warningDark,
    onWarning: AppColors.surfaceHeroDark,
    warningContainer: AppColors.warningContainerDark,
    onWarningContainer: AppColors.warningForegroundDark,
    restricted: AppColors.restrictedDark,
    onRestricted: AppColors.restrictedForegroundDark,
    borderSubtle: AppColors.borderDark,
    focusRing: AppColors.focusDark,
    sidebarOperational: AppColors.surfaceHeroDark,
    sidebarOperationalForeground: AppColors.foregroundDark,
    sidebarAdmin: AppColors.sidebarAdmin,
    sidebarAdminAccent: AppColors.adminAccent,
    chart1: AppColors.chart1Dark,
    chart2: AppColors.chart2Dark,
    chart3: AppColors.chart3Dark,
    chart4: AppColors.chart4Dark,
    chart5: AppColors.chart5Dark,
    atmosphericGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF152A45),
        Color(0xFF0D1E33),
        Color(0xFF091623),
        Color(0xFF0B1520),
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF06101D), Color(0xFF102744)],
    ),
    authGradient: RadialGradient(
      center: Alignment.topLeft,
      radius: 1.6,
      colors: [Color(0xFF173152), Color(0xFF091423), Color(0xFF06101D)],
      stops: [0.0, 0.58, 1.0],
    ),
  );
}
