import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/shared/widgets/app_sync_indicator.dart';
import 'package:gestor_de_estoque/features/dashboard/dashboard_providers.dart';
import 'package:gestor_de_estoque/features/dashboard/data/local/dashboard_fixture.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/presentation/pages/dashboard_page.dart';

class MockDashboardRepository implements DashboardRepository {
  const MockDashboardRepository();

  @override
  Future<DashboardLoadResult> load() async {
    return DashboardLoadResult.ready(buildDashboardFixture());
  }
}

void main() {
  testWidgets(
    'dashboard renderiza metadados de sincronização, gráficos e restrição financeira',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardRepositoryProvider.overrideWithValue(
              const MockDashboardRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const DashboardPage(),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel('Atualizado: 12/06/2026 • 09:40'),
        findsOneWidget,
      );
      expect(find.byType(AppSyncIndicator), findsOneWidget);
      expect(find.text('Meta operacional'), findsOneWidget);
      expect(find.text('Nível de estoque'), findsOneWidget);
      expect(find.text('Financeiro restrito'), findsOneWidget);
      expect(find.text('Movimentos'), findsOneWidget);
      expect(find.text('KPIs resumidos'), findsNothing);
      expect(find.text('Movimentos recentes'), findsNothing);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.drawer, isNull);
    },
  );

  testWidgets('dashboard suporta 320px com textScaler 2.0', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(
            const MockDashboardRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: DashboardPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('VISÃO GERAL'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard reorganiza métricas em viewport ampla', (tester) async {
    tester.view.physicalSize = const Size(900, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(
            const MockDashboardRepository(),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const DashboardPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Indicadores'), findsOneWidget);
    expect(find.byType(AppSyncIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
