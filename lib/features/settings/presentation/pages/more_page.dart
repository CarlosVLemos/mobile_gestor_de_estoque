import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/session_actions.dart';
import '../../../../app/shell/shell_profile.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../../../../app/theme/app_theme_mode_controller.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/section_header.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(shellProfileProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const OperationalTopBar(title: 'Mais'),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          if (_hasIdentity(profile)) ...[
            _IdentitySummary(profile: profile),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
          const SectionHeader(title: 'Conta'),
          const SizedBox(height: AppSpacing.md),
          _SettingsActionCard(
            icon: AppIcons.account,
            title: 'Conta e empresa',
            description: 'Veja os dados da sua conta e da empresa atual.',
            onTap: () => context.push(AppRoutes.context),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionHeader(title: 'Aplicativo'),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: AppDecorations.card(context),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.settings, color: context.colors.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Aparência',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Escolha como o aplicativo acompanha o tema do dispositivo.',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppSegmentedControl<ThemeMode>(
                    semanticLabel: 'Tema do aplicativo',
                    segments: const [
                      AppSegment(
                        value: ThemeMode.system,
                        label: 'Sistema',
                        icon: AppIcons.settings,
                      ),
                      AppSegment(
                        value: ThemeMode.light,
                        label: 'Claro',
                        icon: AppIcons.themeLight,
                      ),
                      AppSegment(
                        value: ThemeMode.dark,
                        label: 'Escuro',
                        icon: AppIcons.themeDark,
                      ),
                    ],
                    selected: themeMode,
                    onSelected: ref
                        .read(appThemeModeProvider.notifier)
                        .setMode,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionHeader(title: 'Sessão'),
          const SizedBox(height: AppSpacing.md),
          _SettingsActionCard(
            icon: AppIcons.logout,
            title: 'Sair',
            description: 'Encerre o acesso desta conta neste dispositivo.',
            destructive: true,
            showTrailing: false,
            onTap: () => _logout(context, ref),
          ),
        ],
      ),
    );
  }

  bool _hasIdentity(ShellProfile profile) {
    return profile.userName.isNotEmpty ||
        profile.userEmail.isNotEmpty ||
        profile.tenantName.isNotEmpty;
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(sessionActionsProvider).logout();
    if (!context.mounted || !result.requiresConfirmation) {
      return;
    }

    final count = result.pendingOutboxCount;
    final operationMessage = count == 1
        ? '1 operação ainda não foi sincronizada.'
        : '$count operações ainda não foram sincronizadas.';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Existem operações pendentes'),
        content: Text(
          '$operationMessage Elas continuarão salvas neste dispositivo e '
          'poderão ser sincronizadas quando este mesmo usuário entrar '
          'novamente nesta empresa. Deseja sair mesmo assim?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sair mesmo assim'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(sessionActionsProvider)
          .logout(confirmPendingOutbox: true);
    }
  }
}

class _IdentitySummary extends StatelessWidget {
  const _IdentitySummary({required this.profile});

  final ShellProfile profile;

  @override
  Widget build(BuildContext context) {
    final title = profile.userName.isNotEmpty
        ? profile.userName
        : (profile.userEmail.isNotEmpty ? profile.userEmail : 'Conta atual');

    return DecoratedBox(
      decoration: AppDecorations.hero(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              AppIcons.account,
              size: AppSizes.emphasisIcon,
              color: context.appColors.onSurfaceHero,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.appColors.onSurfaceHero,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (profile.tenantName.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      profile.tenantName,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.appColors.onSurfaceHero.withValues(
                          alpha: 0.82,
                        ),
                      ),
                    ),
                  ],
                  if (profile.userEmail.isNotEmpty &&
                      profile.userEmail != title) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      profile.userEmail,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.appColors.onSurfaceHero.withValues(
                          alpha: 0.72,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsActionCard extends StatelessWidget {
  const _SettingsActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.destructive = false,
    this.showTrailing = true,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool destructive;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    final foreground = destructive
        ? context.colors.error
        : context.colors.primary;

    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.xlBorder,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: foreground),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: destructive ? foreground : null,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
                  if (showTrailing) ...[
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      AppIcons.arrowForward,
                      size: AppSizes.inlineIcon,
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
