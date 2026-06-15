import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_strings.dart';
import '../router/app_routes.dart';
import '../theme/app_decorations.dart';
import '../theme/app_icons.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_context.dart';
import 'startup_controller.dart';

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(startupControllerProvider, (previous, next) {
      if (next.status == StartupStatus.ready) {
        context.go(AppRoutes.dashboard);
      }
    });

    final state = ref.watch(startupControllerProvider);

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
                        if (state.status == StartupStatus.loading)
                          const LinearProgressIndicator()
                        else
                          DecoratedBox(
                            decoration: AppDecorations.tonalBadge(
                              context,
                              AppStatusTone.error,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              child: Text(
                                state.message ??
                                    'Falha ao iniciar o bootstrap.',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colors.onErrorContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        if (state.status == StartupStatus.failure) ...[
                          const SizedBox(height: AppSpacing.md),
                          TextButton(
                            onPressed: () => ref
                                .read(startupControllerProvider.notifier)
                                .retry(),
                            child: const Text('Tentar novamente'),
                          ),
                        ] else ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Bootstrap local controlado até a futura autenticação mobile.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.appColors.onSurfaceMuted,
                            ),
                          ),
                        ],
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
