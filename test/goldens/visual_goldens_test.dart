import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/app/theme/app_icons.dart';
import 'package:gestor_de_estoque/features/dashboard/dashboard_providers.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/data/local/dashboard_fixture.dart';
import 'package:gestor_de_estoque/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gestor_de_estoque/features/catalog/catalog_providers.dart';
import 'package:gestor_de_estoque/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/data/local/catalog_fixture.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';
import 'package:gestor_de_estoque/features/catalog/presentation/pages/catalog_page.dart';
import 'package:gestor_de_estoque/shared/widgets/app_shell_scaffold.dart';
import 'package:gestor_de_estoque/shared/widgets/app_bottom_navigation.dart';

class MockDashboardRepository implements DashboardRepository {
  const MockDashboardRepository();
  @override
  Future<DashboardLoadResult> load() async {
    return DashboardLoadResult.ready(buildDashboardFixture());
  }
}

class MockCatalogRepository implements CatalogRepository {
  const MockCatalogRepository();
  @override
  Future<CatalogLoadResult> load(CatalogQuery query) async {
    return CatalogLoadResult.ready(
      items: buildCatalogFixture(),
      categories: const ['Todos', 'Proteção', 'Elétrica', 'Acessórios'],
    );
  }
}

void main() {
  setUpAll(() async {
    final fontLoader = FontLoader('Instrument Sans');
    fontLoader.addFont(
      rootBundle.load(
        'assets/fonts/instrument_sans/InstrumentSans-Regular.ttf',
      ),
    );
    fontLoader.addFont(
      rootBundle.load('assets/fonts/instrument_sans/InstrumentSans-Medium.ttf'),
    );
    fontLoader.addFont(
      rootBundle.load(
        'assets/fonts/instrument_sans/InstrumentSans-SemiBold.ttf',
      ),
    );
    fontLoader.addFont(
      rootBundle.load('assets/fonts/instrument_sans/InstrumentSans-Bold.ttf'),
    );
    await fontLoader.load();

    final lucideLoader = FontLoader('packages/lucide_icons_flutter/Lucide');
    lucideLoader.addFont(
      rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
    );
    await lucideLoader.load();
  });

  group('Golden Tests (390x844)', () {
    Future<void> setupScreenSize(WidgetTester tester) async {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(390, 844));
    }

    testWidgets('G-001 - Shell claro', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            home: AppShellScaffold(
              currentIndex: 0,
              destinations: const [
                AppBottomNavigationDestination(
                  label: 'Painel',
                  icon: AppIcons.dashboard,
                ),
                AppBottomNavigationDestination(
                  label: 'Produtos',
                  icon: AppIcons.products,
                ),
                AppBottomNavigationDestination(
                  label: 'Mais',
                  icon: AppIcons.more,
                ),
              ],
              onSelect: (_) {},
              body: const Center(child: Text('Shell Content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AppShellScaffold),
        matchesGoldenFile('goldens/shell_claro.png'),
      );
    });

    testWidgets('G-002 - Shell escuro', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.dark,
            home: AppShellScaffold(
              currentIndex: 1,
              destinations: const [
                AppBottomNavigationDestination(
                  label: 'Painel',
                  icon: AppIcons.dashboard,
                ),
                AppBottomNavigationDestination(
                  label: 'Produtos',
                  icon: AppIcons.products,
                ),
                AppBottomNavigationDestination(
                  label: 'Mais',
                  icon: AppIcons.more,
                ),
              ],
              onSelect: (_) {},
              body: const Center(child: Text('Shell Content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AppShellScaffold),
        matchesGoldenFile('goldens/shell_escuro.png'),
      );
    });

    testWidgets('G-003 - Dashboard claro', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardRepositoryProvider.overrideWithValue(
              const MockDashboardRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(body: DashboardPage()),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(DashboardPage),
        matchesGoldenFile('goldens/dashboard_claro.png'),
      );
    });

    testWidgets('G-004 - Dashboard escuro', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardRepositoryProvider.overrideWithValue(
              const MockDashboardRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const Scaffold(body: DashboardPage()),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(DashboardPage),
        matchesGoldenFile('goldens/dashboard_escuro.png'),
      );
    });

    testWidgets('G-005 - Catalogo claro', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(
              const MockCatalogRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(body: CatalogPage()),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CatalogPage),
        matchesGoldenFile('goldens/catalogo_claro.png'),
      );
    });

    testWidgets('G-006 - Catalogo escuro', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(
              const MockCatalogRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const Scaffold(body: CatalogPage()),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CatalogPage),
        matchesGoldenFile('goldens/catalogo_escuro.png'),
      );
    });
  });
}
