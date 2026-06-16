import 'package:flutter/material.dart';

abstract final class AppTypography {
  const AppTypography._();

  static const String instrumentSansFamily = 'Instrument Sans';
  static const bool hasInstrumentSansAssets = true;

  static String? get fontFamily =>
      hasInstrumentSansAssets ? instrumentSansFamily : null;

  static TextTheme build(ColorScheme colors) {
    final base = TextTheme(
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 34,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: colors.onSurface,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: colors.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        height: 1.16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: colors.onSurface,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.35,
        color: colors.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        height: 1.22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: colors.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: colors.onSurface,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: colors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: colors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: colors.onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colors.onSurface,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: colors.onSurface,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
        color: colors.onSurface,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
        color: colors.onSurface,
      ),
    );

    return base.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
      fontFamily: fontFamily,
    );
  }
}
