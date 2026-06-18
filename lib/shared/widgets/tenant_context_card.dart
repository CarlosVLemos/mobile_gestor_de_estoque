import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_icons.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class TenantContextCard extends StatelessWidget {
  const TenantContextCard({
    super.key,
    required this.tenantName,
    required this.userName,
    required this.userEmail,
  });

  final String tenantName;
  final String userName;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.hero(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.surface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Icon(
                      AppIcons.tenant,
                      color: context.appColors.onSurfaceHero,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'EMPRESA EM USO',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.appColors.onSurfaceHero,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              tenantName,
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.appColors.onSurfaceHero,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Perfil aplicado a esta operação.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.appColors.onSurfaceHero.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: context.colors.surface.withValues(alpha: 0.08),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.surface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Icon(
                          AppIcons.account,
                          color: context.appColors.onSurfaceHero,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuário conectado',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.appColors.onSurfaceHero
                                  .withValues(alpha: 0.68),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            userName,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.appColors.onSurfaceHero,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            userEmail,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.appColors.onSurfaceHero.withValues(
                                alpha: 0.72,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
