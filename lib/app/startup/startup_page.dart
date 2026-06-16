import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_strings.dart';
import '../router/app_routes.dart';
import '../theme/app_decorations.dart';
import '../theme/app_icons.dart';
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
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Icon(
                  AppIcons.dashboard,
                  color: context.colors.primary,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.appName.toUpperCase(),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colors.primary,
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.startupTitle,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  AppStrings.startupMessage,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                ),
                const Spacer(),
                if (state.status == StartupStatus.loading) ...[
                  const SizedBox(width: 140, child: LinearProgressIndicator()),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Carregando...',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                ] else if (state.status == StartupStatus.failure) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.colors.errorContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                        color: context.colors.onErrorContainer.withValues(
                          alpha: 0.18,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message ?? 'Falha ao iniciar o bootstrap.',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colors.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: () => ref
                              .read(startupControllerProvider.notifier)
                              .retry(),
                          icon: const Icon(AppIcons.refresh, size: 16),
                          label: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Text(
                    'Bootstrap local controlado.',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
