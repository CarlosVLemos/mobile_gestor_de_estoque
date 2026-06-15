import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import 'status_badge.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.restrictedLabel,
    this.highlight = false,
  });

  final String label;
  final String? value;
  final String? subtitle;
  final String? restrictedLabel;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final textColor = highlight
        ? tokens.onSurfaceHero
        : context.colors.onSurface;

    return DecoratedBox(
      decoration: highlight
          ? AppDecorations.hero(context)
          : AppDecorations.card(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: context.textTheme.labelMedium?.copyWith(
                color: highlight ? tokens.onSurfaceHero : tokens.onSurfaceMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (value != null)
              Text(
                value!,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: textColor,
                ),
              )
            else
              const StatusBadge(
                label: 'Financeiro restrito',
                tone: AppStatusTone.restricted,
              ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: highlight
                      ? tokens.sidebarOperationalForeground
                      : tokens.onSurfaceMuted,
                ),
              ),
            ],
            if (restrictedLabel != null && value != null) ...[
              const SizedBox(height: AppSpacing.md),
              StatusBadge(
                label: restrictedLabel!,
                tone: AppStatusTone.restricted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
