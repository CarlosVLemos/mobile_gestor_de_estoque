import 'package:flutter/material.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../app/theme/app_decorations.dart';

class ModuleStatusTile extends StatelessWidget {
  const ModuleStatusTile({
    super.key,
    required this.title,
    required this.description,
    required this.available,
    this.icon = AppIcons.storefront,
    this.onTap,
  });

  final String title;
  final String description;
  final bool available;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: context.colors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleSmall),
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
              label: available ? 'Disponível' : 'Fora do escopo',
              tone: available
                  ? AppStatusTone.success
                  : AppStatusTone.restricted,
            ),
          ],
        ),
      ),
    );
  }
}
