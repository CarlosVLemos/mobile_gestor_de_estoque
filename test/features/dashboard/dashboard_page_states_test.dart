import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/dashboard/dashboard_providers.dart';
import 'package:gestor_de_estoque/features/dashboard/data/local/dashboard_fixture.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/entities/dashboard_overview.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('mostra estado restrito', (tester) async {
    await _pumpDashboard(
      tester,
      const DashboardLoadResult.restricted('Sem permissão'),
    );

    expect(find.text('Painel indisponível para este perfil'), findsOneWidget);
    expect(find.text('Sem permissão'), findsOneWidget);
  });

  testWidgets('mostra falha acionável sem cache', (tester) async {
    await _pumpDashboard(
      tester,
      const DashboardLoadResult.failure('Servidor indisponível'),
    );

    expect(find.text('Falha ao preparar o painel'), findsOneWidget);
    expect(find.text('Servidor indisponível'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });

  testWidgets('mantém conteúdo visível no estado offline', (tester) async {
    await _pumpDashboard(
      tester,
      DashboardLoadResult.offline(
        'Exibindo dados locais',
        overview: buildDashboardFixture(),
      ),
    );

    expect(find.text('Exibindo dados locais'), findsOneWidget);
    expect(find.text('Indicadores'), findsOneWidget);
    expect(find.text('Meta operacional'), findsOneWidget);
  });

  testWidgets('mostra estado vazio sem montar indicadores', (tester) async {
    await _pumpDashboard(
      tester,
      const DashboardLoadResult.empty('Sem dados no período'),
    );

    expect(find.text('Sem dados suficientes no momento'), findsOneWidget);
    expect(find.text('Sem dados no período'), findsOneWidget);
    expect(find.text('Indicadores'), findsNothing);
  });

  testWidgets('aceita meta acima de 100% sem falha de layout', (tester) async {
    await _pumpDashboard(
      tester,
      DashboardLoadResult.ready(_overviewWithProgress(1.4)),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Meta superada'), findsOneWidget);
  });

  testWidgets('informa truncamento sem exibir ação inerte', (tester) async {
    await _pumpDashboard(
      tester,
      DashboardLoadResult.ready(_overviewWithLongLists()),
    );

    expect(find.text('5 de 6'), findsNWidgets(2));
    expect(find.text('Alerta 6'), findsNothing);
    expect(find.text('Movimento 6'), findsNothing);
    expect(find.text('Ver todos'), findsNothing);
  });

  testWidgets('formata KPI financeiro liberado em pt-BR', (tester) async {
    await _pumpDashboard(
      tester,
      DashboardLoadResult.ready(_overviewWithFinancialKpi()),
    );

    expect(find.text('R\$ 18.420,30'), findsOneWidget);
    expect(find.text('R\$ 18420.30'), findsNothing);
  });

  testWidgets('não quebra com quantidade negativa inesperada', (tester) async {
    await _pumpDashboard(
      tester,
      DashboardLoadResult.ready(_overviewWithNegativeStock()),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('0'), findsOneWidget);
  });
}

Future<void> _pumpDashboard(
  WidgetTester tester,
  DashboardLoadResult result,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(
          _StaticDashboardRepository(result),
        ),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const DashboardPage()),
    ),
  );
  await tester.pumpAndSettle();
}

class _StaticDashboardRepository implements DashboardRepository {
  const _StaticDashboardRepository(this.result);

  final DashboardLoadResult result;

  @override
  Future<DashboardLoadResult> load() async => result;
}

DashboardOverview _overviewWithProgress(double progress) {
  return DashboardOverview(
    kpis: const [],
    lowStockAlerts: const [],
    recentMovements: const [],
    stockLevelChart: const [],
    operationalGoalChart: DashboardOperationalGoalChart(
      periodLabel: 'Junho',
      targetLabel: 'Meta R\$ 10.000',
      currentLabel: 'Meta superada',
      progress: progress,
    ),
    canViewFinancial: true,
    webDashboardUrl: 'https://example.test',
    updatedAtLabel: 'Agora',
  );
}

DashboardOverview _overviewWithLongLists() {
  return DashboardOverview(
    kpis: const [],
    lowStockAlerts: List.generate(
      6,
      (index) => DashboardStockAlert(
        productName: 'Alerta ${index + 1}',
        stockLabel: '1 unidade',
        toneLabel: 'Atenção',
      ),
    ),
    recentMovements: List.generate(
      6,
      (index) => DashboardMovement(
        productName: 'Movimento ${index + 1}',
        movementLabel: 'Entrada',
        quantityLabel: '+1',
        occurredAtLabel: 'Agora',
      ),
    ),
    stockLevelChart: const [],
    operationalGoalChart: const DashboardOperationalGoalChart(
      periodLabel: 'Junho',
      targetLabel: 'Meta R\$ 10.000',
      currentLabel: 'Atual R\$ 5.000',
      progress: 0.5,
    ),
    canViewFinancial: true,
    webDashboardUrl: 'https://example.test',
    updatedAtLabel: 'Agora',
  );
}

DashboardOverview _overviewWithFinancialKpi() {
  return DashboardOverview(
    kpis: const [
      DashboardKpi(
        label: 'Receita prevista',
        value: '18420.30',
        isCurrency: true,
      ),
    ],
    lowStockAlerts: const [],
    recentMovements: const [],
    stockLevelChart: const [],
    operationalGoalChart: const DashboardOperationalGoalChart(
      periodLabel: 'Junho',
      targetLabel: 'Meta R\$ 10.000',
      currentLabel: 'Atual R\$ 5.000',
      progress: 0.5,
    ),
    canViewFinancial: true,
    webDashboardUrl: 'https://example.test',
    updatedAtLabel: 'Agora',
  );
}

DashboardOverview _overviewWithNegativeStock() {
  return DashboardOverview(
    kpis: const [],
    lowStockAlerts: const [],
    recentMovements: const [],
    stockLevelChart: const [
      DashboardStockLevelPoint(
        label: 'Inválido',
        value: -2,
        toneLabel: 'Crítico',
      ),
    ],
    operationalGoalChart: const DashboardOperationalGoalChart(
      periodLabel: 'Junho',
      targetLabel: 'Meta R\$ 10.000',
      currentLabel: 'Atual R\$ 5.000',
      progress: 0.5,
    ),
    canViewFinancial: true,
    webDashboardUrl: 'https://example.test',
    updatedAtLabel: 'Agora',
  );
}
