import 'package:flutter/material.dart';

import '../../app/theme/app_icons.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class DashboardHero extends StatelessWidget {
  const DashboardHero({
    super.key,
    required this.title,
    required this.message,
    required this.updatedAtLabel,
    required this.financialAccess,
  });

  final String title;
  final String message;
  final String updatedAtLabel;
  final bool financialAccess;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return Container(
      decoration: BoxDecoration(
        gradient: tokens.heroGradient,
        borderRadius: AppRadius.heroBorder,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'ARARA-GASTOS',
                style: context.textTheme.labelSmall?.copyWith(
                  color: tokens.onSurfaceHero.withValues(alpha: 0.7),
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: context.textTheme.headlineMedium?.copyWith(
              color: tokens.onSurfaceHero,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: tokens.onSurfaceHero.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              _HeroMetadataTag(icon: AppIcons.schedule, label: updatedAtLabel),
              _HeroMetadataTag(
                icon: financialAccess ? AppIcons.shield : AppIcons.lock,
                label: financialAccess
                    ? 'Financeiro liberado'
                    : 'Financeiro restrito',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetadataTag extends StatelessWidget {
  const _HeroMetadataTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.onSurfaceHero.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: tokens.onSurfaceHero.withValues(alpha: 0.9),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: tokens.onSurfaceHero,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
