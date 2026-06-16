import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/animated_state_switcher.dart';
import '../../../../shared/widgets/dashboard_hero.dart';
import '../../../../shared/widgets/empty_state_card.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/interactive_feedback.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/offline_state_banner.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../controllers/dashboard_controller.dart';

/// Número máximo de itens exibidos inline antes de oferecer "Ver todos".
const int _kMaxInlineItems = 5;

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const OperationalTopBar(title: 'Painel'),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            DashboardHero(
              title: state.overview?.headerTitle ?? 'Painel operacional',
              message:
                  state.overview?.headerMessage ??
                  'Preparando o resumo operacional do tenant.',
              updatedAtLabel: state.overview?.updatedAtLabel ?? 'Carregando...',
              financialAccess: state.overview?.canViewFinancial ?? false,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            if (state.status == ViewStatus.offline &&
                state.message != null) ...[
              OfflineStateBanner(message: state.message!),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            AnimatedStateSwitcher(
              child: _buildStateContent(context, state, controller),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o conteúdo condicional com Key semântica para animação.
  Widget _buildStateContent(
    BuildContext context,
    dynamic state,
    dynamic controller,
  ) {
    if (state.status == ViewStatus.loading && state.overview == null) {
      return const Center(
        key: ValueKey('dashboard-loading'),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == ViewStatus.restricted) {
      return RestrictedInfoCard(
        key: const ValueKey('dashboard-restricted'),
        title: 'Painel indisponível para este perfil',
        message:
            state.message ??
            'O backend sinalizou que este recorte não pode ser exibido no app.',
      );
    }

    if (state.status == ViewStatus.empty) {
      return EmptyStateCard(
        key: const ValueKey('dashboard-empty'),
        title: 'Sem dados suficientes no momento',
        message:
            state.message ??
            'Assim que o recorte operacional tiver dados, o painel será preenchido.',
      );
    }

    if (state.status == ViewStatus.failure && state.overview == null) {
      return FailureStateCard(
        key: const ValueKey('dashboard-failure'),
        title: 'Falha ao preparar o painel',
        message:
            state.message ??
            'Tente novamente em instantes para recarregar este resumo.',
        action: TextButton(
          onPressed: () => controller.load(),
          child: const Text('Tentar novamente'),
        ),
      );
    }

    if (state.overview == null) {
      return const SizedBox.shrink(key: ValueKey('dashboard-idle'));
    }

    return Column(
      key: const ValueKey('dashboard-ready'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.status == ViewStatus.refreshing)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: LinearProgressIndicator(),
          ),
        if (state.status == ViewStatus.failure && state.message != null) ...[
          FailureStateCard(
            title: 'Atualização remota indisponível',
            message: state.message!,
            action: TextButton(
              onPressed: () => controller.refresh(),
              child: const Text('Tentar atualizar'),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
        ],

        // KPIs em grade 2x2 com LayoutBuilder
        const SectionHeader(
          title: 'KPIs resumidos',
          subtitle: 'Leitura compacta para operação em campo.',
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - AppSpacing.md) / 2;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final kpi in state.overview!.kpis)
                  SizedBox(
                    width: cardWidth,
                    child: InteractiveFeedback(
                      child: KpiCard(
                        label: kpi.label,
                        value: kpi.isCurrency && kpi.value != null
                            ? 'R\$ ${kpi.value}'
                            : kpi.value,
                        subtitle: kpi.subtitle,
                        tone: kpi.isRestricted
                            ? KpiTone.restricted
                            : (kpi.isHighlighted
                                  ? KpiTone.critical
                                  : KpiTone.neutral),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.sectionGap),

        // Alertas consolidados em card único com divisórias
        SectionHeader(
          title: 'Alertas de estoque',
          subtitle: 'Ruptura e baixo saldo visíveis sem abrir o web dashboard.',
          action: state.overview!.lowStockAlerts.length > _kMaxInlineItems
              ? TextButton(onPressed: () {}, child: const Text('Ver todos'))
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.overview!.lowStockAlerts.isEmpty)
          DecoratedBox(
            decoration: AppDecorations.card(context),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'Nenhum alerta de estoque ativo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                ),
              ),
            ),
          )
        else
          DecoratedBox(
            decoration: AppDecorations.card(context),
            child: Column(
              children: [
                for (
                  var i = 0;
                  i <
                      math.min(
                        state.overview!.lowStockAlerts.length,
                        _kMaxInlineItems,
                      );
                  i++
                ) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        StatusBadge(
                          label: state.overview!.lowStockAlerts[i].toneLabel,
                          tone:
                              state.overview!.lowStockAlerts[i].toneLabel ==
                                  'Ruptura'
                              ? AppStatusTone.error
                              : AppStatusTone.warning,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.overview!.lowStockAlerts[i].productName,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                state.overview!.lowStockAlerts[i].stockLabel,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.sectionGap),

        // Movimentos recentes consolidados em card único com divisórias
        SectionHeader(
          title: 'Movimentos recentes',
          subtitle:
              'Últimos eventos resumidos no app. O dashboard web continua disponível para leitura completa.',
          action: state.overview!.recentMovements.length > _kMaxInlineItems
              ? TextButton(onPressed: () {}, child: const Text('Ver todos'))
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.overview!.recentMovements.isEmpty)
          DecoratedBox(
            decoration: AppDecorations.card(context),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'Nenhum movimento registrado recentemente',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                ),
              ),
            ),
          )
        else
          DecoratedBox(
            decoration: AppDecorations.card(context),
            child: Column(
              children: [
                for (
                  var i = 0;
                  i <
                      math.min(
                        state.overview!.recentMovements.length,
                        _kMaxInlineItems,
                      );
                  i++
                ) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    title: Text(state.overview!.recentMovements[i].productName),
                    subtitle: Text(
                      '${state.overview!.recentMovements[i].movementLabel} • ${state.overview!.recentMovements[i].occurredAtLabel}',
                    ),
                    trailing: Text(
                      state.overview!.recentMovements[i].quantityLabel,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
