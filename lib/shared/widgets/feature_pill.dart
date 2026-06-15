import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class FeaturePill extends StatelessWidget {
  const FeaturePill({super.key, required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final background = enabled
        ? context.colors.primaryContainer
        : context.colors.surfaceContainerHigh;
    final foreground = enabled
        ? context.colors.onPrimaryContainer
        : context.appColors.onSurfaceMuted;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
