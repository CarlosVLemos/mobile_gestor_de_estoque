import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/app/theme/app_icons.dart';
import 'package:gestor_de_estoque/shared/widgets/operational_top_bar.dart';
import 'package:gestor_de_estoque/shared/widgets/app_bottom_navigation.dart';
import 'package:gestor_de_estoque/shared/widgets/kpi_card.dart';
import 'package:gestor_de_estoque/shared/widgets/offline_state_banner.dart';
import 'package:gestor_de_estoque/shared/widgets/permission_list_tile.dart';
import 'package:gestor_de_estoque/shared/widgets/product_card.dart';
import 'package:gestor_de_estoque/shared/widgets/section_header.dart';

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
      expect(find.byIcon(AppIcons.search), findsNothing);
      expect(find.byIcon(AppIcons.menu), findsNothing);
    });

    testWidgets('permanece legível em largura compacta e textScaler 2.0', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const Scaffold(
              appBar: OperationalTopBar(
                title: 'Título operacional longo',
                leading: IconButton(onPressed: null, icon: Icon(AppIcons.menu)),
                actions: [
                  IconButton(onPressed: null, icon: Icon(AppIcons.search)),
                  IconButton(onPressed: null, icon: Icon(AppIcons.themeDark)),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Título operacional longo'), findsOneWidget);
      expect(find.byIcon(AppIcons.search), findsOneWidget);
      expect(find.byIcon(AppIcons.themeDark), findsOneWidget);
    });
  });

  group('SectionHeader', () {
    testWidgets('move ação para baixo em largura compacta e texto ampliado', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: SectionHeader(
                  title: 'Carrinho de produtos',
                  action: TextButton(
                    onPressed: null,
                    child: Text('Adicionar produto'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final titleBottom = tester
          .getBottomLeft(find.text('Carrinho de produtos'))
          .dy;
      final actionTop = tester.getTopLeft(find.text('Adicionar produto')).dy;
      expect(actionTop, greaterThan(titleBottom));
    });
  });

  group('Operational state rows', () {
    testWidgets('reflowam em 320px com textScaler 2.0', (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    PermissionListTile(
                      label: 'Consultar catálogo completo',
                      description:
                          'Permissão aplicada conforme o contexto remoto.',
                      allowed: false,
                    ),
                    OfflineStateBanner(
                      message:
                          'Os dados locais continuam visíveis enquanto a conexão não retorna.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Restrito'), findsOneWidget);
      expect(find.text('Offline'), findsOneWidget);
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

    testWidgets('expõe indisponibilidade de venda separada do estoque', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: ProductCard(
              categoryIcon: AppIcons.productProtection,
              product: ProductCardData(
                name: 'Produto bloqueado',
                sku: 'SKU-BLOCK',
                brand: 'Arara',
                stockQuantity: 10,
                stockTone: ProductCardStockTone.available,
                availableForSale: false,
                price: 10,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Estoque saudável'), findsOneWidget);
      expect(find.text('Venda indisponível'), findsOneWidget);
    });

    testWidgets('não exibe estoque negativo recebido por engano', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: ProductCard(
              categoryIcon: AppIcons.productProtection,
              product: ProductCardData(
                name: 'Produto inconsistente',
                sku: 'SKU-NEG',
                brand: 'Arara',
                stockQuantity: -2,
                stockTone: ProductCardStockTone.out,
                availableForSale: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('0 unidades'), findsOneWidget);
      expect(find.text('-2 unidades'), findsNothing);
    });
  });
}
