import 'package:flutter/material.dart';

import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../../../../shared/widgets/status_badge.dart';

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
    final isTextLarge = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final status = StatusBadge(
      label: available ? 'Disponível' : 'Fora do escopo',
      tone: available ? AppStatusTone.success : AppStatusTone.restricted,
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shouldStack = isTextLarge || constraints.maxWidth < 320;
            final content = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                if (!shouldStack) ...[
                  const SizedBox(width: AppSpacing.md),
                  status,
                ],
              ],
            );

            if (!shouldStack) {
              return content;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSizes.emphasisIcon + AppSpacing.md,
                  ),
                  child: status,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
