import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/shared/widgets/animated_state_switcher.dart';

void main() {
  Widget buildApp({required Widget child}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  group('AnimatedStateSwitcher', () {
    testWidgets('renderiza o widget filho com Key', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: const AnimatedStateSwitcher(
            child: Text('Estado A', key: ValueKey('a')),
          ),
        ),
      );

      expect(find.text('Estado A'), findsOneWidget);
    });

    testWidgets('anima a transição entre estados diferentes', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: const AnimatedStateSwitcher(
            child: Text('Loading', key: ValueKey('loading')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Loading'), findsOneWidget);

      // Trocar para novo estado
      await tester.pumpWidget(
        buildApp(
          child: const AnimatedStateSwitcher(
            child: Text('Ready', key: ValueKey('ready')),
          ),
        ),
      );

      // Durante a animação, ambos podem estar presentes brevemente
      await tester.pump(const Duration(milliseconds: 100));

      // Após settle, apenas o novo estado deve estar visível
      await tester.pumpAndSettle();

      expect(find.text('Ready'), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('contém AnimatedSwitcher internamente', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: const AnimatedStateSwitcher(
            child: SizedBox(key: ValueKey('test')),
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    });
  });
}
