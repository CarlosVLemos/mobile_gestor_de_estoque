import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../../../../app/theme/app_theme_mode_controller.dart';
import '../../../../shared/formatters/app_currency_formatter.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/animated_state_switcher.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/empty_state_card.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../shared/widgets/offline_state_banner.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../controllers/dashboard_controller.dart';
import '../state/dashboard_state.dart';

const int _kMaxInlineItems = 5;

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.transparent,
      appBar: OperationalTopBar(
        title: 'Painel',
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
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
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

  Widget _buildStateContent(
    BuildContext context,
    DashboardState state,
    DashboardController controller,
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

    final DashboardOverview overview = state.overview!;

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
        const SectionHeader(title: 'Indicadores'),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - AppSpacing.md) / 2;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final kpi in overview.kpis)
                  SizedBox(
                    width: cardWidth,
                    child: KpiCard(
                      label: kpi.label,
                      value: _formatKpiValue(kpi),
                      subtitle: kpi.subtitle,
                      tone: kpi.isRestricted
                          ? KpiTone.restricted
                          : (kpi.isHighlighted
                                ? KpiTone.critical
                                : KpiTone.neutral),
                    ),
                  ),
                SizedBox(
                  width: cardWidth,
                  child: KpiCard(
                    label: 'Atualização',
                    value: overview.updatedAtLabel,
                    subtitle: overview.canViewFinancial
                        ? 'Financeiro liberado'
                        : 'Financeiro restrito',
                    tone: KpiTone.neutral,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(title: 'Meta operacional'),
        const SizedBox(height: AppSpacing.md),
        _GoalChartCard(chart: overview.operationalGoalChart),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(title: 'Nível de estoque'),
        const SizedBox(height: AppSpacing.md),
        _StockLevelChartCard(points: overview.stockLevelChart),
        const SizedBox(height: AppSpacing.sectionGap),
        SectionHeader(
          title: 'Alertas',
          action: overview.lowStockAlerts.length > _kMaxInlineItems
              ? Text(
                  '$_kMaxInlineItems de ${overview.lowStockAlerts.length}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        if (overview.lowStockAlerts.isEmpty)
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
                        overview.lowStockAlerts.length,
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
                          label: overview.lowStockAlerts[i].toneLabel,
                          tone:
                              overview.lowStockAlerts[i].toneLabel == 'Ruptura'
                              ? AppStatusTone.error
                              : AppStatusTone.warning,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                overview.lowStockAlerts[i].productName,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                overview.lowStockAlerts[i].stockLabel,
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
        SectionHeader(
          title: 'Movimentos',
          action: overview.recentMovements.length > _kMaxInlineItems
              ? Text(
                  '$_kMaxInlineItems de ${overview.recentMovements.length}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        if (overview.recentMovements.isEmpty)
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
                        overview.recentMovements.length,
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
                    title: Text(overview.recentMovements[i].productName),
                    subtitle: Text(
                      '${overview.recentMovements[i].movementLabel} • ${overview.recentMovements[i].occurredAtLabel}',
                    ),
                    trailing: Text(overview.recentMovements[i].quantityLabel),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  void _showSearchMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Busca global ainda não entrou no app.')),
    );
  }

  String? _formatKpiValue(DashboardKpi kpi) {
    final value = kpi.value;
    if (!kpi.isCurrency || value == null || value.startsWith('R\$')) {
      return value;
    }

    final parsed = double.tryParse(value);
    return parsed == null ? value : AppCurrencyFormatter.format(parsed);
  }
}

class _GoalChartCard extends StatelessWidget {
  const _GoalChartCard({required this.chart});

  final DashboardOperationalGoalChart chart;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chart.periodLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              chart.currentLabel,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: chart.progress.isFinite
                    ? chart.progress.clamp(0.0, 1.0).toDouble()
                    : 0,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              chart.targetLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.appColors.onSurfaceMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockLevelChartCard extends StatelessWidget {
  const _StockLevelChartCard({required this.points});

  final List<DashboardStockLevelPoint> points;

  @override
  Widget build(BuildContext context) {
    final highestValue = points.fold<int>(
      1,
      (maxValue, point) => point.value > maxValue ? point.value : maxValue,
    );

    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final point in points)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${math.max(point.value, 0)}'),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        height:
                            120 *
                            (math.max(point.value, 0) / highestValue),
                        decoration: BoxDecoration(
                          color: _barColor(context, point.toneLabel),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        point.label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _barColor(BuildContext context, String toneLabel) {
    return switch (toneLabel) {
      'Crítico' => context.colors.errorContainer,
      'Atenção' => context.colors.tertiaryContainer,
      _ => context.colors.primaryContainer,
    };
  }
}
