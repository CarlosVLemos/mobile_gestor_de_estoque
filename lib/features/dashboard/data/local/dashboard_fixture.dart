import '../../../../core/config/fixture_access_profile.dart';
import '../../domain/entities/dashboard_overview.dart';

DashboardOverview buildDashboardFixture() {
  return DashboardOverview(
    canViewFinancial: appFixtureAccessProfile.canViewFinancialMetrics,
    webDashboardUrl: 'https://app.exemplo/painel',
    updatedAtLabel: 'Atualizado às 09:40',
    kpis: [
      const DashboardKpi(
        label: 'Pedidos em campo',
        value: '128',
        subtitle: '26 aguardando conferência',
        isHighlighted: true,
      ),
      const DashboardKpi(
        label: 'Clientes positivados',
        value: '42',
        subtitle: '8 acima da meta da semana',
      ),
      DashboardKpi(
        label: 'Receita prevista',
        value: appFixtureAccessProfile.canViewFinancialMetrics
            ? '18420.30'
            : null,
        subtitle: appFixtureAccessProfile.canViewFinancialMetrics
            ? 'Meta mensal em andamento'
            : 'Liberada apenas para perfis com permissão financeira',
        isCurrency: true,
        isRestricted: !appFixtureAccessProfile.canViewFinancialMetrics,
      ),
    ],
    stockLevelChart: const [
      DashboardStockLevelPoint(
        label: 'Disponível',
        value: 18,
        toneLabel: 'Estável',
      ),
      DashboardStockLevelPoint(label: 'Baixo', value: 6, toneLabel: 'Atenção'),
      DashboardStockLevelPoint(
        label: 'Ruptura',
        value: 2,
        toneLabel: 'Crítico',
      ),
    ],
    operationalGoalChart: const DashboardOperationalGoalChart(
      periodLabel: 'Junho',
      targetLabel: 'Meta R\$ 24.000',
      currentLabel: 'Atual R\$ 18.420',
      progress: 0.77,
    ),
    lowStockAlerts: const [
      DashboardStockAlert(
        productName: 'Capacete Trail Pro',
        stockLabel: '3 unidades em estoque',
        toneLabel: 'Atenção',
      ),
      DashboardStockAlert(
        productName: 'Luva Carbon Flex',
        stockLabel: '0 unidade disponível',
        toneLabel: 'Ruptura',
      ),
    ],
    recentMovements: const [
      DashboardMovement(
        productName: 'Capacete Trail Pro',
        movementLabel: 'Saída para venda',
        quantityLabel: '2 unidades',
        occurredAtLabel: '12 jun, 08:20',
      ),
      DashboardMovement(
        productName: 'Kit Sinalização LED',
        movementLabel: 'Reposição recebida',
        quantityLabel: '15 unidades',
        occurredAtLabel: '12 jun, 07:45',
      ),
      DashboardMovement(
        productName: 'Luva Carbon Flex',
        movementLabel: 'Separação interna',
        quantityLabel: '1 unidade',
        occurredAtLabel: '11 jun, 18:05',
      ),
    ],
  );
}
