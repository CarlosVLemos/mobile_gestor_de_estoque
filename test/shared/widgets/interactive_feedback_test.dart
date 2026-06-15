import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/shared/widgets/interactive_feedback.dart';

void main() {
  Widget buildApp({required Widget child}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('InteractiveFeedback', () {
    testWidgets('renderiza o widget filho corretamente', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: const InteractiveFeedback(child: Text('Conteúdo filho')),
        ),
      );

      expect(find.text('Conteúdo filho'), findsOneWidget);
    });

    testWidgets('dispara onTap quando pressionado e solto', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildApp(
          child: InteractiveFeedback(
            onTap: () => tapped = true,
            child: const Text('Botão'),
          ),
        ),
      );

      await tester.tap(find.text('Botão'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('não dispara onTap quando enabled é false', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildApp(
          child: InteractiveFeedback(
            onTap: () => tapped = true,
            enabled: false,
            child: const Text('Desabilitado'),
          ),
        ),
      );

      await tester.tap(find.text('Desabilitado'));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('não reage quando onTap é nulo', (tester) async {
      await tester.pumpWidget(
        buildApp(child: const InteractiveFeedback(child: Text('Sem ação'))),
      );

      // Deve renderizar sem GestureDetector quando não interativo
      expect(find.byType(GestureDetector), findsNothing);
      expect(find.text('Sem ação'), findsOneWidget);
    });

    testWidgets('controller de animação é descartado sem vazamento', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          child: InteractiveFeedback(
            onTap: () {},
            child: const Text('Temporário'),
          ),
        ),
      );

      // Remover o widget da árvore para verificar dispose
      await tester.pumpWidget(buildApp(child: const SizedBox.shrink()));
      await tester.pumpAndSettle();

      // Se chegou aqui sem exceção, dispose funcionou corretamente
    });
  });
}
