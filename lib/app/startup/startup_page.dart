import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_decorations.dart';
import '../theme/app_icons.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_context.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: AppDecorations.atmosphericBackground(context),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.compactContentMaxWidth,
                ),
                child: DecoratedBox(
                  decoration: AppDecorations.elevatedCard(context),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: AppDecorations.hero(context),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Icon(
                              AppIcons.dashboard,
                              color: context.appColors.onSurfaceHero,
                              size: AppSizes.emphasisIcon + 6,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          AppStrings.startupLabel,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm + AppSpacing.xxs),
                        Text(
                          AppStrings.appName,
                          style: context.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          AppStrings.startupTitle,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          AppStrings.startupMessage,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.appColors.onSurfaceMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        DecoratedBox(
                          decoration: AppDecorations.tonalBadge(
                            context,
                            AppStatusTone.restricted,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: Text(
                              'Tema global pronto para receber features reais.',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.appColors.onRestricted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
