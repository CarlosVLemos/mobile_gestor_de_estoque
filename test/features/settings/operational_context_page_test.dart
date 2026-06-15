import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/settings/presentation/pages/operational_context_page.dart';

void main() {
  testWidgets('contexto operacional exibe tenant, usuário e permissões', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: OperationalContextPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Arara Centro Logistico'), findsOneWidget);
    expect(find.text('Maria Oliveira'), findsOneWidget);
    expect(find.text('Consultar catálogo'), findsOneWidget);
    expect(find.text('Ver métricas financeiras'), findsOneWidget);
  });
}
