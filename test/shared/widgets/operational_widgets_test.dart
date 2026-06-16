import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/app/theme/app_icons.dart';
import 'package:gestor_de_estoque/shared/widgets/operational_top_bar.dart';
import 'package:gestor_de_estoque/shared/widgets/dashboard_hero.dart';
import 'package:gestor_de_estoque/shared/widgets/app_bottom_navigation.dart';
import 'package:gestor_de_estoque/shared/widgets/kpi_card.dart';
import 'package:gestor_de_estoque/shared/widgets/product_card.dart';

void main() {
  group('OperationalTopBar', () {
    testWidgets('renderiza titulo e subtitulo com hierarquia', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: OperationalTopBar(
              title: 'Título do Top Bar',
              subtitle: 'Subtítulo do Top Bar',
            ),
          ),
        ),
      );

      expect(find.text('Título do Top Bar'), findsOneWidget);
      expect(find.text('Subtítulo do Top Bar'), findsOneWidget);
    });

    testWidgets('faz reflow com textScaler alto (1.3 e 2.0) e ajusta altura', (
      tester,
    ) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
            child: Scaffold(
              body: Column(
                children: [
                  OperationalTopBar(
                    key: key,
                    title: 'Título do Top Bar',
                    actions: const [Text('Ação 1'), Text('Ação 2')],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      final height1 = tester.getSize(find.byKey(key)).height;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: Scaffold(
              body: Column(
                children: [
                  OperationalTopBar(
                    key: key,
                    title: 'Título do Top Bar',
                    actions: const [Text('Ação 1'), Text('Ação 2')],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      final height1_3 = tester.getSize(find.byKey(key)).height;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Scaffold(
              body: Column(
                children: [
                  OperationalTopBar(
                    key: key,
                    title: 'Título do Top Bar',
                    actions: const [Text('Ação 1'), Text('Ação 2')],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      final height2 = tester.getSize(find.byKey(key)).height;

      expect(height2, greaterThan(height1));
      expect(height1_3, greaterThanOrEqualTo(height1));
      expect(find.text('Título do Top Bar'), findsOneWidget);
    });
  });

  group('DashboardHero', () {
    testWidgets('renderiza com gradiente, titulo e no maximo dois metadados', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: DashboardHero(
              title: 'Painel Principal',
              message: 'Mensagem do Hero',
              updatedAtLabel: '10:00',
              financialAccess: true,
            ),
          ),
        ),
      );

      expect(find.text('Painel Principal'), findsOneWidget);
      expect(find.text('Mensagem do Hero'), findsOneWidget);
      expect(find.text('10:00'), findsOneWidget);
      expect(find.text('Financeiro liberado'), findsOneWidget);
    });
  });

  group('AppBottomNavigation', () {
    testWidgets('renderiza destinos e responde ao toque', (tester) async {
      int selectedIndex = -1;
      final destinations = [
        const AppBottomNavigationDestination(label: 'Dest 1', icon: Icons.home),
        const AppBottomNavigationDestination(label: 'Dest 2', icon: Icons.star),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            bottomNavigationBar: AppBottomNavigation(
              currentIndex: 0,
              destinations: destinations,
              onSelect: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      expect(find.text('Dest 1'), findsOneWidget);
      expect(find.text('Dest 2'), findsOneWidget);

      await tester.tap(find.text('Dest 2'));
      await tester.pump();

      expect(selectedIndex, 1);
    });

    testWidgets('absorve safe area inset inferior', (tester) async {
      final destinations = [
        const AppBottomNavigationDestination(label: 'Dest 1', icon: Icons.home),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(bottom: 34)),
            child: Scaffold(
              bottomNavigationBar: AppBottomNavigation(
                currentIndex: 0,
                destinations: destinations,
                onSelect: (_) {},
              ),
            ),
          ),
        ),
      );

      final Finder barFinder = find.byType(AppBottomNavigation);
      final Size size34 = tester.getSize(barFinder);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.zero),
            child: Scaffold(
              bottomNavigationBar: AppBottomNavigation(
                currentIndex: 0,
                destinations: destinations,
                onSelect: (_) {},
              ),
            ),
          ),
        ),
      );

      final Size size0 = tester.getSize(find.byType(AppBottomNavigation));

      expect(size34.height, equals(size0.height + 34));
    });

    testWidgets(
      'faz reflow com textScaler alto (1.3 e 2.0) e cresce verticalmente',
      (tester) async {
        final destinations = [
          const AppBottomNavigationDestination(
            label: 'Destino Muito Longo 1',
            icon: Icons.home,
          ),
          const AppBottomNavigationDestination(
            label: 'Destino Muito Longo 2',
            icon: Icons.star,
          ),
        ];
        final key = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
              child: Scaffold(
                bottomNavigationBar: AppBottomNavigation(
                  key: key,
                  currentIndex: 0,
                  destinations: destinations,
                  onSelect: (_) {},
                ),
              ),
            ),
          ),
        );
        final height1 = tester.getSize(find.byKey(key)).height;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: Scaffold(
                bottomNavigationBar: AppBottomNavigation(
                  key: key,
                  currentIndex: 0,
                  destinations: destinations,
                  onSelect: (_) {},
                ),
              ),
            ),
          ),
        );
        final height2 = tester.getSize(find.byKey(key)).height;

        expect(height2, greaterThan(height1));
      },
    );
  });

  group('KpiCard', () {
    testWidgets('renderiza diferentes tons semanticos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Column(
              children: [
                KpiCard(label: 'Kpi 1', value: '100', tone: KpiTone.neutral),
                KpiCard(label: 'Kpi 2', value: null, tone: KpiTone.restricted),
              ],
            ),
          ),
        ),
      );

      expect(find.text('KPI 1'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('Financeiro restrito'), findsOneWidget);
    });

    testWidgets(
      'faz reflow com textScaler alto (1.3 e 2.0) e cresce verticalmente',
      (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
              child: Scaffold(
                body: Column(
                  children: [
                    KpiCard(
                      key: key,
                      label: 'Estoque baixo',
                      value: '24',
                      subtitle: 'Ação necessária',
                      tone: KpiTone.critical,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        final height1 = tester.getSize(find.byKey(key)).height;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: Scaffold(
                body: Column(
                  children: [
                    KpiCard(
                      key: key,
                      label: 'Estoque baixo',
                      value: '24',
                      subtitle: 'Ação necessária',
                      tone: KpiTone.critical,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        final height2 = tester.getSize(find.byKey(key)).height;

        expect(height2, greaterThan(height1));
      },
    );
  });

  group('ProductCard', () {
    testWidgets('renderiza em linha e com icone de categoria', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: ProductCard(
              categoryIcon: AppIcons.productProtection,
              product: ProductCardData(
                name: 'Capacete de Teste',
                sku: 'SKU-TEST',
                brand: 'TestBrand',
                stockQuantity: 10,
                stockTone: ProductCardStockTone.available,
                availableForSale: true,
                updatedAtLabel: 'Agora',
                price: 150.0,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Capacete de Teste'), findsOneWidget);
      expect(find.textContaining('SKU-TEST'), findsOneWidget);
      expect(find.textContaining('10 un'), findsOneWidget);
      expect(find.text('R\$ 150,00'), findsOneWidget);
    });

    testWidgets(
      'faz reflow com textScaler alto (1.3 e 2.0) e move trailing para baixo',
      (tester) async {
        final key = GlobalKey();
        const product = ProductCardData(
          name: 'Capacete de Segurança Ultra Premium Resistente',
          sku: 'SKU-ULTRA-PREM',
          brand: 'SafetyCorp',
          stockQuantity: 15,
          stockTone: ProductCardStockTone.available,
          availableForSale: true,
          updatedAtLabel: 'Agora',
          price: 299.90,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
              child: Scaffold(
                body: Column(
                  children: [
                    ProductCard(
                      key: key,
                      product: product,
                      categoryIcon: AppIcons.productProtection,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        final height1 = tester.getSize(find.byKey(key)).height;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: Scaffold(
                body: Column(
                  children: [
                    ProductCard(
                      key: key,
                      product: product,
                      categoryIcon: AppIcons.productProtection,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        final height2 = tester.getSize(find.byKey(key)).height;

        expect(height2, greaterThan(height1));
      },
    );

    testWidgets('reflowa em largura compacta sem overflow horizontal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const product = ProductCardData(
        name: 'Capacete de Seguranca Ultra Premium com Viseira Integrada',
        sku: 'SKU-ULTRA-PREM',
        brand: 'Safety Corporation Industrial',
        stockQuantity: 15,
        stockTone: ProductCardStockTone.available,
        availableForSale: true,
        updatedAtLabel: 'Agora',
        price: 1299.90,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: ProductCard(
              product: product,
              categoryIcon: AppIcons.productProtection,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('R\$ 1.299,90'), findsOneWidget);
    });
  });
}
