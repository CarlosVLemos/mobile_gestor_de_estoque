import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import 'status_badge.dart';

enum KpiTone { neutral, positive, warning, critical, restricted }

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.tone = KpiTone.neutral,
  });

  final String label;
  final String? value;
  final String? subtitle;
  final KpiTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    final (
      backgroundColor,
      textColor,
      valueColor,
      subtitleColor,
      borderColor,
    ) = switch (tone) {
      KpiTone.neutral => (
        context.colors.surfaceContainerLow,
        tokens.onSurfaceMuted,
        context.colors.onSurface,
        tokens.onSurfaceMuted,
        tokens.borderSubtle,
      ),
      KpiTone.positive => (
        tokens.successContainer,
        tokens.onSuccessContainer,
        tokens.onSuccessContainer,
        tokens.onSuccessContainer.withValues(alpha: 0.8),
        tokens.successContainer,
      ),
      KpiTone.warning => (
        tokens.warningContainer,
        tokens.onWarningContainer,
        tokens.onWarningContainer,
        tokens.onWarningContainer.withValues(alpha: 0.8),
        tokens.warningContainer,
      ),
      KpiTone.critical => (
        context.colors.errorContainer,
        context.colors.onErrorContainer,
        context.colors.onErrorContainer,
        context.colors.onErrorContainer.withValues(alpha: 0.8),
        context.colors.errorContainer,
      ),
      KpiTone.restricted => (
        tokens.restricted,
        tokens.onRestricted,
        tokens.onRestricted,
        tokens.onRestricted.withValues(alpha: 0.8),
        tokens.restricted,
      ),
    };

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(AppRadius.radiusXl),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: context.textTheme.labelMedium?.copyWith(color: textColor),
          ),
          const SizedBox(height: AppSpacing.md),
          if (tone == KpiTone.restricted || value == null)
            const StatusBadge(
              label: 'Financeiro restrito',
              tone: AppStatusTone.restricted,
            )
          else
            Text(
              value!,
              style: context.textTheme.headlineSmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                color: subtitleColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
