import 'package:flutter/material.dart';

@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.surfaceMuted,
    required this.surfaceHero,
    required this.onSurfaceHero,
    required this.onSurfaceMuted,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.restricted,
    required this.onRestricted,
    required this.borderSubtle,
    required this.focusRing,
    required this.sidebarOperational,
    required this.sidebarOperationalForeground,
    required this.sidebarAdmin,
    required this.sidebarAdminAccent,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.atmosphericGradient,
    required this.heroGradient,
    required this.authGradient,
  });

  final Color surfaceMuted;
  final Color surfaceHero;
  final Color onSurfaceHero;
  final Color onSurfaceMuted;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color restricted;
  final Color onRestricted;
  final Color borderSubtle;
  final Color focusRing;
  final Color sidebarOperational;
  final Color sidebarOperationalForeground;
  final Color sidebarAdmin;
  final Color sidebarAdminAccent;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;
  final Gradient atmosphericGradient;
  final Gradient heroGradient;
  final Gradient authGradient;

  @override
  AppColorTokens copyWith({
    Color? surfaceMuted,
    Color? surfaceHero,
    Color? onSurfaceHero,
    Color? onSurfaceMuted,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? restricted,
    Color? onRestricted,
    Color? borderSubtle,
    Color? focusRing,
    Color? sidebarOperational,
    Color? sidebarOperationalForeground,
    Color? sidebarAdmin,
    Color? sidebarAdminAccent,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Gradient? atmosphericGradient,
    Gradient? heroGradient,
    Gradient? authGradient,
  }) {
    return AppColorTokens(
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceHero: surfaceHero ?? this.surfaceHero,
      onSurfaceHero: onSurfaceHero ?? this.onSurfaceHero,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      restricted: restricted ?? this.restricted,
      onRestricted: onRestricted ?? this.onRestricted,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      focusRing: focusRing ?? this.focusRing,
      sidebarOperational: sidebarOperational ?? this.sidebarOperational,
      sidebarOperationalForeground:
          sidebarOperationalForeground ?? this.sidebarOperationalForeground,
      sidebarAdmin: sidebarAdmin ?? this.sidebarAdmin,
      sidebarAdminAccent: sidebarAdminAccent ?? this.sidebarAdminAccent,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
      atmosphericGradient: atmosphericGradient ?? this.atmosphericGradient,
      heroGradient: heroGradient ?? this.heroGradient,
      authGradient: authGradient ?? this.authGradient,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) {
      return this;
    }

    return AppColorTokens(
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceHero: Color.lerp(surfaceHero, other.surfaceHero, t)!,
      onSurfaceHero: Color.lerp(onSurfaceHero, other.onSurfaceHero, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      restricted: Color.lerp(restricted, other.restricted, t)!,
      onRestricted: Color.lerp(onRestricted, other.onRestricted, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      sidebarOperational: Color.lerp(
        sidebarOperational,
        other.sidebarOperational,
        t,
      )!,
      sidebarOperationalForeground: Color.lerp(
        sidebarOperationalForeground,
        other.sidebarOperationalForeground,
        t,
      )!,
      sidebarAdmin: Color.lerp(sidebarAdmin, other.sidebarAdmin, t)!,
      sidebarAdminAccent: Color.lerp(
        sidebarAdminAccent,
        other.sidebarAdminAccent,
        t,
      )!,
      chart1: Color.lerp(chart1, other.chart1, t)!,
      chart2: Color.lerp(chart2, other.chart2, t)!,
      chart3: Color.lerp(chart3, other.chart3, t)!,
      chart4: Color.lerp(chart4, other.chart4, t)!,
      chart5: Color.lerp(chart5, other.chart5, t)!,
      atmosphericGradient: Gradient.lerp(
        atmosphericGradient,
        other.atmosphericGradient,
        t,
      )!,
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t)!,
      authGradient: Gradient.lerp(authGradient, other.authGradient, t)!,
    );
  }
}
