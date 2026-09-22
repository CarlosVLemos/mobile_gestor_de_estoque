import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/session_actions.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/app/theme/app_icons.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gestor_de_estoque/features/auth/presentation/pages/change_password_page.dart';
import 'package:gestor_de_estoque/features/auth/presentation/pages/login_page.dart';
import 'package:gestor_de_estoque/features/auth/presentation/state/auth_state.dart';
import 'package:gestor_de_estoque/features/catalog/catalog_providers.dart';
import 'package:gestor_de_estoque/features/catalog/data/local/catalog_fixture.dart';
import 'package:gestor_de_estoque/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';
import 'package:gestor_de_estoque/features/catalog/presentation/pages/catalog_page.dart';
import 'package:gestor_de_estoque/features/dashboard/dashboard_providers.dart';
import 'package:gestor_de_estoque/features/dashboard/data/local/dashboard_fixture.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_reference_data.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';
import 'package:gestor_de_estoque/features/sales/presentation/controllers/sales_controller.dart';
import 'package:gestor_de_estoque/features/sales/presentation/pages/sales_page.dart';
import 'package:gestor_de_estoque/features/sales/presentation/state/sales_state.dart';
import 'package:gestor_de_estoque/features/sales/sales_providers.dart';
import 'package:gestor_de_estoque/features/settings/domain/entities/operational_context.dart';
import 'package:gestor_de_estoque/features/settings/presentation/pages/more_page.dart';
import 'package:gestor_de_estoque/features/settings/presentation/pages/operational_context_page.dart';
import 'package:gestor_de_estoque/features/settings/settings_providers.dart';
import 'package:gestor_de_estoque/shared/widgets/app_bottom_navigation.dart';
import 'package:gestor_de_estoque/shared/widgets/app_shell_scaffold.dart';
import 'package:flutter_riverpod/misc.dart';

class _DashboardFixtureRepository implements DashboardRepository {
  const _DashboardFixtureRepository();
  @override
  Future<DashboardLoadResult> load() async => DashboardLoadResult.ready(buildDashboardFixture());
}
class _CatalogFixtureRepository implements CatalogRepository {
  const _CatalogFixtureRepository();
  @override
  Future<CatalogLoadResult> load(CatalogQuery query) async => CatalogLoadResult.ready(items: buildCatalogFixture(), categories: const ['Todos', 'Proteção', 'Elétrica', 'Acessórios']);
}

void main() {
  setUpAll(() async {
    final fonts = FontLoader('Instrument Sans');
    for (final asset in const ['assets/fonts/instrument_sans/InstrumentSans-Regular.ttf', 'assets/fonts/instrument_sans/InstrumentSans-Medium.ttf', 'assets/fonts/instrument_sans/InstrumentSans-SemiBold.ttf', 'assets/fonts/instrument_sans/InstrumentSans-Bold.ttf']) { fonts.addFont(rootBundle.load(asset)); }
    await fonts.load();
    final lucide = FontLoader('packages/lucide_icons_flutter/Lucide');
    lucide.addFont(rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'));
    await lucide.load();
  });

  group('Spec 014 visual goldens (390x844)', () {
    Future<void> pump(WidgetTester tester, Widget child, ThemeData theme, [List<Override> overrides = const []]) async {
      await TestWidgetsFlutterBinding.ensureInitialized().setSurfaceSize(const Size(390, 844));
      addTearDown(() => TestWidgetsFlutterBinding.ensureInitialized().setSurfaceSize(null));
      await tester.pumpWidget(ProviderScope(overrides: overrides, child: MaterialApp(theme: theme, darkTheme: AppTheme.dark, home: child)));
      await tester.pump(); await tester.pumpAndSettle();
    }
    Future<void> golden(Finder finder, String name) => expectLater(finder, matchesGoldenFile('goldens/$name.png'));

    testWidgets('G-001 Shell light', (t) async { await pump(t, _shell(0), AppTheme.light); await golden(find.byType(AppShellScaffold), 'shell_claro'); });
    testWidgets('G-002 Shell dark', (t) async { await pump(t, _shell(1), AppTheme.dark); await golden(find.byType(AppShellScaffold), 'shell_escuro'); });
    testWidgets('G-003 Login light', (t) async { await pump(t, const LoginPage(), AppTheme.light, [authControllerProvider.overrideWith(_GoldenLoginController.new)]); await golden(find.byType(LoginPage), 'login_claro'); });
    testWidgets('G-004 Login dark', (t) async { await pump(t, const LoginPage(), AppTheme.dark, [authControllerProvider.overrideWith(_GoldenLoginController.new)]); await golden(find.byType(LoginPage), 'login_escuro'); });
    testWidgets('G-005 Change Password light', (t) async { await pump(t, const ChangePasswordPage(), AppTheme.light, [authControllerProvider.overrideWith(_GoldenPasswordController.new)]); await golden(find.byType(ChangePasswordPage), 'change_password_claro'); });
    testWidgets('G-006 Change Password dark', (t) async { await pump(t, const ChangePasswordPage(), AppTheme.dark, [authControllerProvider.overrideWith(_GoldenPasswordController.new)]); await golden(find.byType(ChangePasswordPage), 'change_password_escuro'); });
    testWidgets('G-007 Dashboard light', (t) async { await pump(t, const DashboardPage(), AppTheme.light, [dashboardRepositoryProvider.overrideWithValue(const _DashboardFixtureRepository())]); await golden(find.byType(DashboardPage), 'dashboard_claro'); });
    testWidgets('G-008 Dashboard dark', (t) async { await pump(t, const DashboardPage(), AppTheme.dark, [dashboardRepositoryProvider.overrideWithValue(const _DashboardFixtureRepository())]); await golden(find.byType(DashboardPage), 'dashboard_escuro'); });
    testWidgets('G-009 Catalog light', (t) async { await pump(t, const CatalogPage(), AppTheme.light, [catalogRepositoryProvider.overrideWithValue(const _CatalogFixtureRepository())]); await golden(find.byType(CatalogPage), 'catalogo_claro'); });
    testWidgets('G-010 Catalog dark', (t) async { await pump(t, const CatalogPage(), AppTheme.dark, [catalogRepositoryProvider.overrideWithValue(const _CatalogFixtureRepository())]); await golden(find.byType(CatalogPage), 'catalogo_escuro'); });
    testWidgets('G-011 Sales New light', (t) async { await pump(t, const SalesPage(), AppTheme.light, _salesOverrides()); await golden(find.byType(SalesPage), 'vendas_nova_claro'); });
    testWidgets('G-012 Sales New dark', (t) async { await pump(t, const SalesPage(), AppTheme.dark, _salesOverrides()); await golden(find.byType(SalesPage), 'vendas_nova_escuro'); });
    testWidgets('G-013 Sales History light', (t) async { await pump(t, const SalesPage(), AppTheme.light, _salesOverrides(history: true)); await t.tap(find.byKey(const ValueKey('sales-segment-history'))); await t.pumpAndSettle(); await golden(find.byType(SalesPage), 'vendas_historico_claro'); });
    testWidgets('G-014 Sales History dark', (t) async { await pump(t, const SalesPage(), AppTheme.dark, _salesOverrides(history: true)); await t.tap(find.byKey(const ValueKey('sales-segment-history'))); await t.pumpAndSettle(); await golden(find.byType(SalesPage), 'vendas_historico_escuro'); });
    testWidgets('G-015 More light', (t) async { await pump(t, const MorePage(), AppTheme.light, _settingsOverrides()); await golden(find.byType(MorePage), 'mais_claro'); });
    testWidgets('G-016 More dark', (t) async { await pump(t, const MorePage(), AppTheme.dark, _settingsOverrides()); await golden(find.byType(MorePage), 'mais_escuro'); });
    testWidgets('G-017 Account Company light', (t) async { await pump(t, const OperationalContextPage(), AppTheme.light, _settingsOverrides()); await golden(find.byType(OperationalContextPage), 'conta_empresa_claro'); });
    testWidgets('G-018 Account Company dark', (t) async { await pump(t, const OperationalContextPage(), AppTheme.dark, _settingsOverrides()); await golden(find.byType(OperationalContextPage), 'conta_empresa_escuro'); });
  });
}

AppShellScaffold _shell(int index) => AppShellScaffold(currentIndex: index, destinations: const [AppBottomNavigationDestination(label: 'Painel', icon: AppIcons.dashboard), AppBottomNavigationDestination(label: 'Produtos', icon: AppIcons.products), AppBottomNavigationDestination(label: 'Vendas', icon: AppIcons.sales), AppBottomNavigationDestination(label: 'Mais', icon: AppIcons.more)], onSelect: (_) {}, body: const Center(child: Text('Visão operacional')));
class _GoldenLoginController extends AuthController { @override AuthState build() => const AuthState(status: AuthStatus.unauthenticated); }
class _GoldenPasswordController extends AuthController { @override AuthState build() => const AuthState(status: AuthStatus.passwordChangeRequired); }
class _GoldenSalesController extends SalesController { @override SalesState build() => SalesState(clients: const [], products: const [], selectedClient: const SaleClientOption(id: '201', name: 'Cliente Norte', code: 'CLI-201', city: 'Belém - PA'), cartItems: const {'101': SaleCartItem(productId: '101', name: 'Capacete Trail Pro', sku: 'SKU-101', quantity: 2, unitPrice: 89.9), '102': SaleCartItem(productId: '102', name: 'Lanterna de segurança', sku: 'SKU-102', quantity: 1, unitPrice: 39.9)}); }
List<Override> _salesOverrides({bool history = false}) => [shellProfileProvider.overrideWithValue(_profile), salesControllerProvider.overrideWith(_GoldenSalesController.new), persistedSalesProvider.overrideWith((ref) => Stream.value(history ? _history : const []))];
final _history = [PersistedSaleSummary(localSaleId: 'confirmed', clientName: 'Cliente Confirmado', createdAt: DateTime(2026, 9, 22, 10, 32), status: SaleSyncStatus.confirmed, itemCount: 2, proposalRevision: 0, totalAmount: 179.8), PersistedSaleSummary(localSaleId: 'pending', clientName: 'Cliente Pendente', createdAt: DateTime(2026, 9, 22, 9, 15), status: SaleSyncStatus.pending, itemCount: 1, proposalRevision: 0, totalAmount: 39.9), PersistedSaleSummary(localSaleId: 'review', clientName: 'Cliente em revisão', createdAt: DateTime(2026, 9, 21, 16), status: SaleSyncStatus.requiresAcceptance, itemCount: 1, proposalRevision: 2, proposalJson: '{"proposal":true}')];
List<Override> _settingsOverrides() => [shellProfileProvider.overrideWithValue(_profile), currentOperationalContextProvider.overrideWithValue(_context), sessionActionsProvider.overrideWithValue(SessionActions(({bool confirmPendingOutbox = false}) async => const LogoutAttempt.completed()))];
final _profile = ShellProfile(userName: 'Maria Oliveira', userEmail: 'maria@arara-gastos.test', tenantName: 'Arara Centro Logístico', tenantSlug: 'arara-centro', features: const {'catalog', 'sales'}, permissions: const {'products_view': true, 'sales_create': true, 'view_financial_metrics': true});
final _context = OperationalContext(userName: 'Maria Oliveira', userEmail: 'maria@arara-gastos.test', tenantName: 'Arara Centro Logístico', tenantSlug: 'arara-centro', features: const {'catalog', 'sales'}, permissions: const {'products_view': true, 'sales_create': true, 'view_financial_metrics': true});
