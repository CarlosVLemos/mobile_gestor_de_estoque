import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/sales/presentation/controllers/pending_sales_controller.dart';
import 'package:gestor_de_estoque/features/sales/presentation/pages/sales_page.dart';

void main() {
  testWidgets(
    'vendas registra intenção local em memória e mantém financeiro restrito',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(theme: AppTheme.light, home: const SalesPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Financeiro restrito'), findsWidgets);

      await tester.tap(find.text('Selecionar cliente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Loja Horizonte'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Adicionar produto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Capacete Trail Pro').last);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Registrar venda'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Registrar venda'));
      await tester.pumpAndSettle();
      expect(container.read(pendingSalesProvider), hasLength(1));
      expect(find.textContaining('armazenada offline'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0.0, 500.0));
      await tester.pumpAndSettle();

      expect(find.textContaining('armazenada localmente'), findsOneWidget);
    },
  );
}
