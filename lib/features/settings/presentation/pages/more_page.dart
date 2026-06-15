import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/operational_page_header.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../app/router/app_routes.dart';
import '../controllers/operational_context_controller.dart';
import '../widgets/module_status_tile.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(operationalContextControllerProvider);

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        OperationalPageHeader(
          eyebrow: 'NAVEGAÇÃO AUXILIAR',
          title: 'Mais opções da operação',
          description:
              'Contexto da operação, módulos futuros e atalhos que não entram na navegação primária.',
          icon: AppIcons.more,
          tags: [
            OperationalHeaderTag(
              label: state.context?.isFeatureEnabled('catalog') ?? false
                  ? 'Catálogo ativo'
                  : 'Catálogo fora do contexto',
              tone: state.context?.isFeatureEnabled('catalog') ?? false
                  ? AppStatusTone.success
                  : AppStatusTone.restricted,
            ),
            OperationalHeaderTag(
              label: state.context?.permissionGranted('products_view') ?? false
                  ? 'Consulta liberada'
                  : 'Consulta restrita',
              tone: state.context?.permissionGranted('products_view') ?? false
                  ? AppStatusTone.success
                  : AppStatusTone.warning,
            ),
          ],
          metrics: const [
            OperationalHeaderMetric(
              label: 'Módulos futuros',
              value: '3 trilhas',
              icon: AppIcons.bolt,
            ),
            OperationalHeaderMetric(
              label: 'Destinos rápidos',
              value: '1 ativo agora',
              icon: AppIcons.arrowForward,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(
          title: 'Acesso rápido',
          subtitle: 'Atalhos para contexto e módulos fora do núcleo principal.',
        ),
        const SizedBox(height: AppSpacing.md),

        // Atalhos consolidados em card único com divisórias
        DecoratedBox(
          decoration: AppDecorations.glassSurface(context),
          child: Column(
            children: [
              ModuleStatusTile(
                title: 'Contexto operacional',
                description:
                    'Mostra tenant, usuário, features e permissões que moldam a experiência do app.',
                available: true,
                icon: AppIcons.account,
                onTap: () {
                  context.push(AppRoutes.context);
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ModuleStatusTile(
                title: 'Vendas',
                description:
                    'O fluxo offline ainda depende da futura spec de autenticação e dos contratos de intenção de venda.',
                available: false,
                icon: AppIcons.sales,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ModuleStatusTile(
                title: 'Estoque',
                description:
                    'A leitura operacional de estoque aparece no painel e no catálogo, mas o módulo dedicado ainda não entrou no escopo.',
                available: false,
                icon: AppIcons.inventory,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ModuleStatusTile(
                title: 'Relatórios',
                description:
                    'Relatórios mobile dependem de endpoints futuros. O app mantém só a trilha de contexto e permissão por enquanto.',
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
    );
  }
}
