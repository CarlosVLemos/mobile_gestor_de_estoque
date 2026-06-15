import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import 'status_badge.dart';

class PermissionListTile extends StatelessWidget {
  const PermissionListTile({
    super.key,
    required this.label,
    required this.description,
    required this.allowed,
  });

  final String label;
  final String description;
  final bool allowed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            StatusBadge(
              label: allowed ? 'Liberado' : 'Restrito',
              tone: allowed ? AppStatusTone.success : AppStatusTone.restricted,
            ),
          ],
        ),
      ),
    );
  }
}
