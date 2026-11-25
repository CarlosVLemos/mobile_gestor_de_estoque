import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/catalog/presentation/widgets/catalog_filter_bar.dart';

void main() {
  testWidgets('limpa a busca e mantém o filtro selecionado', (tester) async {
    final changes = <String>[];
    final categories = <String>[];
    Widget build(String value) => MaterialApp(
      home: Scaffold(
        body: CatalogFilterBar(
          searchValue: value,
          categories: const ['Todos', 'Proteção'],
          selectedCategory: 'Proteção',
          onSearchChanged: changes.add,
          onCategorySelected: categories.add,
        ),
      ),
    );

    await tester.pumpWidget(build(''));
    expect(find.text('Buscar produtos'), findsOneWidget);
    expect(find.byTooltip('Limpar busca'), findsNothing);
    await tester.enterText(find.byType(TextFormField), 'SKU-123');
    await tester.pump();
    expect(changes, ['SKU-123']);
    expect(find.byTooltip('Limpar busca'), findsOneWidget);
    await tester.tap(find.byTooltip('Limpar busca'));
    await tester.pump();
    expect(changes, ['SKU-123', '']);
    expect(tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text, '');
    expect(tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Proteção')).selected, isTrue);
    expect(categories, isEmpty);
  });

  testWidgets('sincroniza alteração externa e trata largura compacta', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Widget build(String value) => MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Scaffold(
          body: SingleChildScrollView(
            child: CatalogFilterBar(
              searchValue: value,
              categories: const ['Todos', 'Proteção'],
              selectedCategory: 'Todos',
              onSearchChanged: (_) {},
              onCategorySelected: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(build('anterior'));
    await tester.pumpWidget(build('novo'));
    expect(tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text, 'novo');
    expect(find.text('Buscar produtos'), findsOneWidget);
    expect(find.byTooltip('Limpar busca'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
