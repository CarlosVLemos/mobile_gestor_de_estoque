import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/catalog/presentation/pages/catalog_page.dart';

void main() {
  testWidgets('catálogo mostra produto e preço restrito sem falhar', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: CatalogPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Capacete Trail Pro'), findsOneWidget);
    expect(find.text('Preço restrito'), findsWidgets);
    expect(find.text('Kit Sinalização LED'), findsOneWidget);
  });
}
