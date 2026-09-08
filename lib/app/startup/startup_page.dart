import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_strings.dart';
import '../theme/app_decorations.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_context.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/state/auth_state.dart';

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final unavailable =
        state.status == AuthStatus.unavailable ||
        state.status == AuthStatus.failure;
    return Scaffold(
      body: DecoratedBox(
        decoration: AppDecorations.atmosphericBackground(context),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    unavailable
                        ? 'Não foi possível validar a sessão'
                        : 'Validando sua sessão',
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    unavailable
                        ? (state.failure?.message ??
                              'Verifique sua conexão e tente novamente.')
                        : 'Aguarde enquanto preparamos o acesso seguro.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (unavailable)
                    FilledButton.icon(
                      onPressed: () =>
                          ref.read(authControllerProvider.notifier).restore(),
                      icon: const Icon(AppIcons.refresh),
                      label: const Text('Tentar novamente'),
                    )
                  else
                    const SizedBox(
                      width: 140,
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
