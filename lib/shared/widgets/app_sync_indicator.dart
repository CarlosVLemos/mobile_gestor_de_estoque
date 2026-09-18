import 'package:flutter/material.dart';

import '../../app/theme/app_icons.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

enum AppSyncIndicatorState { idle, syncing, success, warning }

/// Metadata compacta de sincronização. Não deve competir com KPI de negócio.
class AppSyncIndicator extends StatelessWidget {
  const AppSyncIndicator({
    super.key,
    required this.value,
    this.label = 'Sincronização',
    this.state = AppSyncIndicatorState.idle,
    this.onTap,
  });

  final String label;
  final String value;
  final AppSyncIndicatorState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < 240 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.3;
        final icon = _icon();
        final iconColor = _iconColor(context);
        final metadata = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.appColors.onSurfaceMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AnimatedSwitcher(
              duration: AppDurations.normal,
              switchInCurve: AppCurves.standard,
              switchOutCurve: AppCurves.standard,
              child: Text(
                value,
                key: ValueKey(value),
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(height: AppSpacing.sm),
              metadata,
            ],
          );
        }

        return Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: metadata),
          ],
        );
      },
    );

    return Semantics(
      container: true,
      button: onTap != null,
      label: '$label: $value',
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: context.colors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xlBorder,
            side: BorderSide(color: context.appColors.borderSubtle),
          ),
          child: InkWell(
            borderRadius: AppRadius.xlBorder,
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _icon() => switch (state) {
    AppSyncIndicatorState.idle => AppIcons.schedule,
    AppSyncIndicatorState.syncing => AppIcons.refresh,
    AppSyncIndicatorState.success => AppIcons.success,
    AppSyncIndicatorState.warning => AppIcons.warning,
  };

  Color _iconColor(BuildContext context) => switch (state) {
    AppSyncIndicatorState.idle => context.appColors.onSurfaceMuted,
    AppSyncIndicatorState.syncing => context.colors.primary,
    AppSyncIndicatorState.success => context.appColors.success,
    AppSyncIndicatorState.warning => context.appColors.warning,
  };
}
