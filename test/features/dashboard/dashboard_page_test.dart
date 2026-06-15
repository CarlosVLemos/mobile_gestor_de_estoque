import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('dashboard renderiza KPIs e restrição financeira explícita', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: DashboardPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Pedidos em campo'), findsOneWidget);
    expect(find.text('Financeiro restrito'), findsOneWidget);
    expect(find.text('Movimentos recentes'), findsOneWidget);
  });
}
