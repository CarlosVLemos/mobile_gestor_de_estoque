import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/sales/presentation/controllers/pending_sales_controller.dart';
import 'package:gestor_de_estoque/features/sales/presentation/pages/sales_page.dart';

void main() {
  testWidgets(
    'vendas cria rascunho de sessão e mantém financeiro restrito',
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

      await tester.ensureVisible(find.text('Criar rascunho'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Criar rascunho'));
      await tester.pumpAndSettle();
      expect(container.read(pendingSalesProvider), hasLength(1));
      expect(find.textContaining('mantido somente nesta sessão'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0.0, 500.0));
      await tester.pumpAndSettle();

      expect(find.textContaining('Fechar o app descarta'), findsOneWidget);
    },
  );

  testWidgets('permanece sem overflow em largura compacta e texto ampliado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: SalesPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Vendas'), findsOneWidget);
    expect(find.text('Selecionar cliente'), findsOneWidget);

    await tester.tap(find.text('Selecionar cliente'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Loja Horizonte'), findsOneWidget);

    await tester.tap(find.text('Loja Horizonte'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar produto'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Preço restrito'), findsOneWidget);
  });

  testWidgets('bloqueia formulário sem feature ou permissão de vendas', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shellProfileProvider.overrideWithValue(
            ShellProfile(
              userName: 'Maria',
              userEmail: 'maria@example.test',
              tenantName: 'Arara',
              tenantSlug: 'arara',
              features: const {'catalog'},
              permissions: const {'sales_create': false},
            ),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const SalesPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Vendas indisponíveis'), findsOneWidget);
    expect(find.text('Selecionar cliente'), findsNothing);
    expect(find.text('Criar rascunho'), findsNothing);
  });

  testWidgets('exibe preços e total somente com permissão financeira', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shellProfileProvider.overrideWithValue(
            ShellProfile(
              userName: 'Maria',
              userEmail: 'maria@example.test',
              tenantName: 'Arara',
              tenantSlug: 'arara',
              features: const {'sales'},
              permissions: const {
                'sales_create': true,
                'view_financial_metrics': true,
              },
            ),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const SalesPage()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Selecionar cliente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loja Horizonte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar produto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kit Sinalização LED').last);
    await tester.pumpAndSettle();

    expect(find.text('Unitário R\$ 49,90'), findsOneWidget);
    expect(find.text('Subtotal R\$ 49,90'), findsOneWidget);
    expect(find.text('Total R\$ 49,90'), findsOneWidget);
  });
}
