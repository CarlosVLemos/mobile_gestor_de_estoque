import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/shell/shell_profile.dart';
import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_icons.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellProfile = ref.watch(shellProfileProvider);
    final drawerWidth =
        ((MediaQuery.sizeOf(context).width * 0.58).clamp(240.0, 320.0) as num)
            .toDouble();

    return Drawer(
      width: drawerWidth,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            DecoratedBox(
              decoration: AppDecorations.hero(context),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _DrawerBadge(),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      shellProfile.userName,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.appColors.onSurfaceHero,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      shellProfile.userEmail,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.appColors.onSurfaceHero.withValues(
                          alpha: 0.76,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _DrawerActionTile(
              icon: AppIcons.account,
              title: 'Ver conta',
              onTap: () {
                final navigator = Navigator.of(context);
                final navigatorContext = navigator.context;
                navigator.pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (navigatorContext.mounted) {
                    GoRouter.of(navigatorContext).push(AppRoutes.context);
                  }
                });
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            _DrawerActionTile(
              icon: AppIcons.tune,
              title: 'Alterar nome',
              onTap: () async {
                final navigator = Navigator.of(context);
                final navigatorContext = navigator.context;
                navigator.pop();
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (!navigatorContext.mounted) {
                    return;
                  }

                  await _showEditNameSheet(
                    navigatorContext,
                    ref,
                    initialValue: shellProfile.userName,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditNameSheet(
    BuildContext context,
    WidgetRef ref, {
    required String initialValue,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final updatedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alterar nome',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Mudança local nesta sessão.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appColors.onSurfaceMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => Navigator.of(context).pop(value),
                decoration: const InputDecoration(
                  labelText: 'Nome exibido',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop(controller.text),
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();

    if (updatedValue == null ||
        updatedValue.trim().isEmpty ||
        !context.mounted) {
      return;
    }

    ref
        .read(shellDisplayNameControllerProvider.notifier)
        .updateName(updatedValue);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nome atualizado localmente nesta sessão.')),
    );
  }
}

class _DrawerActionTile extends StatelessWidget {
  const _DrawerActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(AppIcons.arrowForward),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _DrawerBadge extends StatelessWidget {
  const _DrawerBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.tonalBadge(context, AppStatusTone.success),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          'Conta',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.appColors.onSuccessContainer,
          ),
        ),
      ),
    );
  }
}
