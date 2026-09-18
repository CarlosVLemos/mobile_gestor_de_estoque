import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/shared/widgets/app_metric_card.dart';
import 'package:gestor_de_estoque/shared/widgets/app_search_field.dart';
import 'package:gestor_de_estoque/shared/widgets/app_segmented_control.dart';
import 'package:gestor_de_estoque/shared/widgets/app_state_panel.dart';
import 'package:gestor_de_estoque/shared/widgets/app_sync_indicator.dart';

void main() {
  Widget buildApp(
    Widget child, {
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  group('AppStatePanel', () {
    testWidgets('mantém estados semanticamente distintos', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const Column(
            children: [
              AppStatePanel(
                tone: AppStatePanelTone.empty,
                title: 'Sem itens',
                message: 'Nenhum item disponível.',
              ),
              AppStatePanel(
                tone: AppStatePanelTone.failure,
                title: 'Falha ao carregar',
                message: 'Tente novamente.',
              ),
              AppStatePanel(
                tone: AppStatePanelTone.restricted,
                title: 'Acesso restrito',
                message: 'Seu perfil não possui acesso.',
              ),
              AppStatePanel(
                tone: AppStatePanelTone.offline,
                message: 'Os dados locais continuam disponíveis.',
                layout: AppStatePanelLayout.banner,
              ),
              AppStatePanel(
                tone: AppStatePanelTone.info,
                title: 'Informação operacional',
                message: 'Uma orientação importante.',
              ),
            ],
          ),
        ),
      );

      expect(find.text('Sem dados'), findsOneWidget);
      expect(find.text('Falha'), findsOneWidget);
      expect(find.text('Restrito'), findsOneWidget);
      expect(find.text('Offline'), findsOneWidget);
      expect(find.text('Informação'), findsOneWidget);
    });

    testWidgets('reflowa em 320px com text scaler 2.0 no tema escuro', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildApp(
          const AppStatePanel(
            tone: AppStatePanelTone.offline,
            message:
                'Os dados locais continuam visíveis enquanto a conexão não retorna.',
            layout: AppStatePanelLayout.banner,
          ),
          themeMode: ThemeMode.dark,
          textScaler: const TextScaler.linear(2),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Offline'), findsOneWidget);
    });
  });

  group('AppMetricCard', () {
    testWidgets('diferencia métrica principal, secundária e compacta', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Column(
            children: [
              AppMetricCard(label: 'Pedidos', value: '128'),
              AppMetricCard(
                label: 'Meta auxiliar',
                value: '42',
                emphasis: AppMetricEmphasis.secondary,
              ),
              AppMetricCard(
                label: 'Atualização',
                value: 'Hoje, 09:40',
                emphasis: AppMetricEmphasis.compact,
              ),
            ],
          ),
        ),
      );

      expect(find.text('PEDIDOS'), findsOneWidget);
      expect(find.text('META AUXILIAR'), findsOneWidget);
      expect(find.text('ATUALIZAÇÃO'), findsOneWidget);
      expect(find.text('Hoje, 09:40'), findsOneWidget);
    });

    testWidgets('representa restrição sem inventar valor', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppMetricCard(
            label: 'Receita',
            value: null,
            tone: AppMetricTone.restricted,
          ),
        ),
      );

      expect(find.text('Financeiro restrito'), findsOneWidget);
    });
  });

  group('AppSearchField', () {
    testWidgets('encaminha busca e ação de limpar sem criar regra própria', (
      tester,
    ) async {
      var query = '';
      var cleared = false;

      await tester.pumpWidget(
        buildApp(
          AppSearchField(
            hintText: 'Buscar por nome ou SKU',
            onChanged: (value) => query = value,
            onClear: () => cleared = true,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'capacete');
      await tester.tap(find.byTooltip('Limpar busca'));

      expect(query, 'capacete');
      expect(cleared, isTrue);
    });
  });

  group('AppSegmentedControl', () {
    testWidgets('alterna seleção e preserva responsabilidade no consumidor', (
      tester,
    ) async {
      var selected = 'new';

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return AppSegmentedControl<String>(
                segments: const [
                  AppSegment(value: 'new', label: 'Nova venda'),
                  AppSegment(value: 'history', label: 'Histórico'),
                ],
                selected: selected,
                onSelected: (value) => setState(() => selected = value),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Histórico'));
      await tester.pumpAndSettle();

      expect(selected, 'history');
    });

    testWidgets('empilha em 320px com text scaler 2.0', (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildApp(
          AppSegmentedControl<String>(
            segments: const [
              AppSegment(value: 'new', label: 'Nova venda'),
              AppSegment(value: 'history', label: 'Histórico'),
            ],
            selected: 'new',
            onSelected: (_) {},
          ),
          textScaler: const TextScaler.linear(2),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final firstBottom = tester.getBottomLeft(find.text('Nova venda')).dy;
      final secondTop = tester.getTopLeft(find.text('Histórico')).dy;
      expect(secondTop, greaterThan(firstBottom));
    });
  });

  group('AppSyncIndicator', () {
    testWidgets('apresenta sincronização como metadata compacta', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppSyncIndicator(
            value: 'Hoje, 09:40',
            state: AppSyncIndicatorState.success,
          ),
        ),
      );

      expect(find.text('SINCRONIZAÇÃO'), findsOneWidget);
      expect(find.text('Hoje, 09:40'), findsOneWidget);
      expect(find.byType(AppMetricCard), findsNothing);
    });
  });
}
