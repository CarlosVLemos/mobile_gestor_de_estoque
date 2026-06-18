import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
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
    'dashboard renderiza card de atualização, gráficos e restrição financeira',
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

      expect(find.text('ATUALIZAÇÃO'), findsOneWidget);
      expect(find.text('Meta operacional'), findsOneWidget);
      expect(find.text('Nível de estoque'), findsOneWidget);
      expect(find.text('Financeiro restrito'), findsNWidgets(2));
      expect(find.text('Movimentos'), findsOneWidget);
      expect(find.text('KPIs resumidos'), findsNothing);
      expect(find.text('Movimentos recentes'), findsNothing);
    },
  );
}
