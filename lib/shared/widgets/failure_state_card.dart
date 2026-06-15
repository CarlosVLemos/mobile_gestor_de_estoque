import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_icons.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class FailureStateCard extends StatelessWidget {
  const FailureStateCard({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(AppIcons.error, color: context.colors.error),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: context.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.appColors.onSurfaceMuted,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
