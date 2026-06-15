import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_icons.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import 'status_badge.dart';

enum OperationalPageHeaderTone { dark, light }

class OperationalHeaderMetric {
  const OperationalHeaderMetric({
    required this.label,
    required this.value,
    this.icon = AppIcons.insights,
  });

  final String label;
  final String value;
  final IconData icon;
}

class OperationalHeaderTag {
  const OperationalHeaderTag({required this.label, required this.tone});

  final String label;
  final AppStatusTone tone;
}

class OperationalPageHeader extends StatelessWidget {
  const OperationalPageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    this.tone = OperationalPageHeaderTone.light,
    this.action,
    this.tags = const [],
    this.metrics = const [],
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final OperationalPageHeaderTone tone;
  final Widget? action;
  final List<OperationalHeaderTag> tags;
  final List<OperationalHeaderMetric> metrics;

  bool get _isDark => tone == OperationalPageHeaderTone.dark;

  @override
  Widget build(BuildContext context) {
    final foreground = _isDark
        ? context.appColors.onSurfaceHero
        : context.colors.onSurface;
    final muted = _isDark
        ? context.appColors.onSurfaceHero.withValues(alpha: 0.78)
        : context.appColors.onSurfaceMuted;

    return DecoratedBox(
      decoration: _isDark
          ? AppDecorations.hero(context)
          : AppDecorations.elevatedCard(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(
              top: -38,
              right: -18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (_isDark
                              ? context.colors.primary
                              : context.colors.primaryContainer)
                          .withValues(alpha: _isDark ? 0.16 : 0.7),
                ),
                child: const SizedBox(width: 140, height: 140),
              ),
            ),
            Positioned(
              bottom: -52,
              left: -20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (_isDark
                              ? context.colors.tertiary
                              : context.colors.tertiaryContainer)
                          .withValues(alpha: _isDark ? 0.14 : 0.92),
                ),
                child: const SizedBox(width: 124, height: 124),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color:
                              (_isDark
                                      ? context.colors.surface
                                      : context.colors.primaryContainer)
                                  .withValues(alpha: _isDark ? 0.12 : 1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                (_isDark
                                        ? context.colors.surface
                                        : context.colors.primary)
                                    .withValues(alpha: _isDark ? 0.12 : 0.08),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            icon,
                            color: _isDark
                                ? context.appColors.onSurfaceHero
                                : context.colors.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // ignore: use_null_aware_elements
                      if (action != null) action!,
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    eyebrow,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: _isDark ? foreground : context.colors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    title,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: muted,
                      height: 1.5,
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final tag in tags)
                          StatusBadge(label: tag.label, tone: tag.tone),
                      ],
                    ),
                  ],
                  if (metrics.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: [
                        for (final metric in metrics)
                          _OperationalHeaderMetricCard(
                            metric: metric,
                            isDark: _isDark,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OperationalHeaderMetricCard extends StatelessWidget {
  const _OperationalHeaderMetricCard({
    required this.metric,
    required this.isDark,
  });

  final OperationalHeaderMetric metric;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final foreground = isDark
        ? context.appColors.onSurfaceHero
        : context.colors.onSurface;
    final muted = isDark
        ? context.appColors.onSurfaceHero.withValues(alpha: 0.72)
        : context.colors.onSurfaceVariant;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 132, maxWidth: 180),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              (isDark
                      ? context.colors.surface
                      : context.colors.surfaceContainerLowest)
                  .withValues(alpha: isDark ? 0.08 : 0.84),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: (isDark ? context.colors.surface : context.colors.primary)
                .withValues(alpha: isDark ? 0.1 : 0.08),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? context.colors.primary
                              : context.colors.primaryContainer)
                          .withValues(alpha: isDark ? 0.18 : 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(
                    metric.icon,
                    size: 16,
                    color: isDark
                        ? context.appColors.onSurfaceHero
                        : context.colors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.label.toUpperCase(),
                      style: context.textTheme.labelSmall?.copyWith(
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      metric.value,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
