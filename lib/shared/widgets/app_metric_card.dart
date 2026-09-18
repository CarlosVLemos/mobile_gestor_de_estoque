import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import 'status_badge.dart';

enum AppMetricEmphasis { primary, secondary, compact }

enum AppMetricTone { neutral, positive, warning, critical, restricted }

/// Métrica visual com hierarquia explícita.
///
/// Use [AppMetricEmphasis.primary] para KPIs de negócio. Metadata e métricas
/// auxiliares devem usar [secondary] ou [compact].
class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.tone = AppMetricTone.neutral,
    this.emphasis = AppMetricEmphasis.primary,
    this.icon,
    this.restrictedLabel = 'Financeiro restrito',
  });

  final String label;
  final String? value;
  final String? subtitle;
  final AppMetricTone tone;
  final AppMetricEmphasis emphasis;
  final IconData? icon;
  final String restrictedLabel;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(context);
    final compact = emphasis == AppMetricEmphasis.compact;
    final padding = compact ? AppSpacing.md : AppSpacing.lg;

    return Semantics(
      container: true,
      label: tone == AppMetricTone.restricted || value == null
          ? '$label, $restrictedLabel'
          : '$label, $value',
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: const BorderRadius.all(AppRadius.radiusXl),
            border: Border.all(color: palette.border),
          ),
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      label.toUpperCase(),
                      style: context.textTheme.labelMedium?.copyWith(
                        color: palette.label,
                      ),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(icon, size: 18, color: palette.label),
                  ],
                ],
              ),
              SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
              if (tone == AppMetricTone.restricted || value == null)
                StatusBadge(
                  label: restrictedLabel,
                  tone: AppStatusTone.restricted,
                )
              else
                Text(
                  value!,
                  style: _valueStyle(context)?.copyWith(
                    color: palette.value,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: palette.subtitle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? _valueStyle(BuildContext context) {
    return switch (emphasis) {
      AppMetricEmphasis.primary => context.textTheme.headlineSmall,
      AppMetricEmphasis.secondary => context.textTheme.titleLarge,
      AppMetricEmphasis.compact => context.textTheme.titleMedium,
    };
  }

  _MetricPalette _palette(BuildContext context) {
    final tokens = context.appColors;
    return switch (tone) {
      AppMetricTone.neutral => _MetricPalette(
        background: context.colors.surfaceContainerLow,
        label: tokens.onSurfaceMuted,
        value: context.colors.onSurface,
        subtitle: tokens.onSurfaceMuted,
        border: tokens.borderSubtle,
      ),
      AppMetricTone.positive => _MetricPalette(
        background: tokens.successContainer,
        label: tokens.onSuccessContainer,
        value: tokens.onSuccessContainer,
        subtitle: tokens.onSuccessContainer.withValues(alpha: 0.8),
        border: tokens.successContainer,
      ),
      AppMetricTone.warning => _MetricPalette(
        background: tokens.warningContainer,
        label: tokens.onWarningContainer,
        value: tokens.onWarningContainer,
        subtitle: tokens.onWarningContainer.withValues(alpha: 0.8),
        border: tokens.warningContainer,
      ),
      AppMetricTone.critical => _MetricPalette(
        background: context.colors.errorContainer,
        label: context.colors.onErrorContainer,
        value: context.colors.onErrorContainer,
        subtitle: context.colors.onErrorContainer.withValues(alpha: 0.8),
        border: context.colors.errorContainer,
      ),
      AppMetricTone.restricted => _MetricPalette(
        background: tokens.restricted,
        label: tokens.onRestricted,
        value: tokens.onRestricted,
        subtitle: tokens.onRestricted.withValues(alpha: 0.8),
        border: tokens.restricted,
      ),
    };
  }
}

class _MetricPalette {
  const _MetricPalette({
    required this.background,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.border,
  });

  final Color background;
  final Color label;
  final Color value;
  final Color subtitle;
  final Color border;
}
