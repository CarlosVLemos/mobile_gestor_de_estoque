import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/state/auth_state.dart';
import '../../shared/widgets/app_state_panel.dart';
import '../localization/app_strings.dart';
import '../theme/app_decorations.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_context.dart';

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.primaryContainer,
                        borderRadius: AppRadius.xlBorder,
                        border: Border.all(color: context.appColors.borderSubtle),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Icon(
                          AppIcons.dashboard,
                          color: context.colors.primary,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      AppStrings.appName,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (unavailable)
                      AppStatePanel(
                        tone: AppStatePanelTone.failure,
                        title: 'Não foi possível validar sua sessão',
                        message: state.failure?.message ??
                            'Verifique sua conexão e tente novamente.',
                        action: FilledButton.icon(
                          onPressed: () => ref
                              .read(authControllerProvider.notifier)
                              .restore(),
                          icon: const Icon(AppIcons.refresh),
                          label: const Text('Tentar novamente'),
                        ),
                      )
                    else
                      DecoratedBox(
                        decoration: AppDecorations.elevatedCard(context),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Preparando seu ambiente',
                                textAlign: TextAlign.center,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Estamos validando sua sessão.',
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.appColors.onSurfaceMuted,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Semantics(
                                label: 'Validando sessão',
                                child: LinearProgressIndicator(),
                              ),
                            ],
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
    );
  }
}
