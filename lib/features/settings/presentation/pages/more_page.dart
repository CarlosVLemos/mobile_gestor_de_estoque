import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_mode_controller.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../controllers/operational_context_controller.dart';
import '../widgets/module_status_tile.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(operationalContextControllerProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.transparent,
      appBar: OperationalTopBar(
        title: 'Mais',
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(AppIcons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        showSearchAction: true,
        onSearchPressed: () => _showSearchMessage(context),
        themeMode: themeMode,
        onThemeToggle: () {
          ref
              .read(appThemeModeProvider.notifier)
              .toggle(MediaQuery.platformBrightnessOf(context));
        },
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SectionHeader(title: 'Acesso rápido'),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: AppDecorations.glassSurface(context),
            child: Column(
              children: [
                ModuleStatusTile(
                  title: 'Contexto operacional',
                  description: 'Conta, tenant, features e permissões.',
                  available: true,
                  icon: AppIcons.account,
                  onTap: () => context.push(AppRoutes.context),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ModuleStatusTile(
                  title: 'Estoque',
                  description: 'Leitura dedicada ainda fora do escopo.',
                  available: false,
                  icon: AppIcons.inventory,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ModuleStatusTile(
                  title: 'Relatórios',
                  description: 'Aguardando endpoints móveis.',
                  available: false,
                  icon: AppIcons.dashboard,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          if (state.status == ViewStatus.failure)
            FailureStateCard(
              title: 'Não foi possível montar o contexto auxiliar',
              message: state.message ?? 'Tente novamente em instantes.',
              action: TextButton(
                onPressed: () => ref
                    .read(operationalContextControllerProvider.notifier)
                    .load(),
                child: const Text('Tentar novamente'),
              ),
            )
          else if (state.context != null)
            DecoratedBox(
              decoration: AppDecorations.glassSurface(context),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    StatusBadge(
                      label: state.context!.isFeatureEnabled('catalog')
                          ? 'Catálogo ativo'
                          : 'Catálogo indisponível',
                      tone: state.context!.isFeatureEnabled('catalog')
                          ? AppStatusTone.success
                          : AppStatusTone.restricted,
                    ),
                    StatusBadge(
                      label: state.context!.permissionGranted('products_view')
                          ? 'Consulta liberada'
                          : 'Consulta restrita',
                      tone: state.context!.permissionGranted('products_view')
                          ? AppStatusTone.success
                          : AppStatusTone.restricted,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSearchMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Busca global ainda não entrou no app.')),
    );
  }
}
