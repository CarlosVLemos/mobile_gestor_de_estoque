import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/local_context_lifecycle.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/sales/application/use_cases/register_sale_use_case.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_reference_data.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';
import 'package:gestor_de_estoque/features/sales/domain/repositories/sales_repository.dart';
import 'package:gestor_de_estoque/features/sales/presentation/pages/sales_page.dart';
import 'package:gestor_de_estoque/features/sales/sales_providers.dart';

void main() {
  testWidgets('registra venda real e não exibe fallback de sessão', (
    tester,
  ) async {
    final repository = _Repository();
    await tester.pumpWidget(_page(repository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selecionar cliente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cliente Real'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar produto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Produto Drift').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Registrar venda'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registrar venda'));
    await tester.pumpAndSettle();

    expect(repository.draft?.clientId, '201');
    expect(repository.draft?.items.single.productId, '101');
    expect(find.textContaining('registrada localmente'), findsOneWidget);
    expect(find.textContaining('Somente nesta sessão'), findsNothing);
  });

  testWidgets('busca cliente por nome, código e cidade antes da seleção', (
    tester,
  ) async {
    await tester.pumpWidget(_page(_Repository(), references: _searchReferences()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selecionar cliente'));
    await tester.pumpAndSettle();

    final search = find.byType(TextField);
    await tester.enterText(search, 'CLIENTE REAL');
    await tester.pump();
    expect(find.text('Cliente Real'), findsOneWidget);
    expect(find.text('Cliente Exemplo'), findsNothing);

    await tester.enterText(search, 'cli-202');
    await tester.pump();
    expect(find.text('Cliente Exemplo'), findsOneWidget);
    expect(find.text('Cliente Real'), findsNothing);

    await tester.enterText(search, 'BELÉM');
    await tester.pump();
    expect(find.text('Cliente Real'), findsOneWidget);
    expect(find.text('Cliente Exemplo'), findsNothing);

    await tester.enterText(search, 'sem resultado');
    await tester.pump();
    expect(find.text('Nenhum cliente encontrado para essa busca.'),
        findsOneWidget);

    await tester.enterText(search, 'cli-202');
    await tester.pump();
    await tester.tap(find.text('Cliente Exemplo'));
    await tester.pumpAndSettle();
    expect(find.text('Cliente Exemplo'), findsOneWidget);
    expect(find.text('Trocar cliente'), findsOneWidget);
  });

  testWidgets('busca produto por nome e SKU antes de adicionar', (tester) async {
    await tester.pumpWidget(_page(_Repository(), references: _searchReferences()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar produto'));
    await tester.pumpAndSettle();

    final search = find.byType(TextField);
    await tester.enterText(search, 'SKU-102');
    await tester.pump();
    expect(find.text('Produto Exemplo'), findsOneWidget);
    expect(find.text('Produto Drift'), findsNothing);
    expect(find.text('Preço restrito'), findsOneWidget);

    await tester.enterText(search, 'produto drift');
    await tester.pump();
    expect(find.text('Produto Drift'), findsOneWidget);
    expect(find.text('Produto Exemplo'), findsNothing);

    await tester.enterText(search, 'sem resultado');
    await tester.pump();
    expect(find.text('Nenhum produto encontrado para essa busca.'),
        findsOneWidget);

    await tester.enterText(search, 'sku-102');
    await tester.pump();
    await tester.tap(find.text('Produto Exemplo'));
    await tester.pumpAndSettle();
    expect(find.text('Produto Exemplo'), findsOneWidget);
    expect(find.text('Preço restrito'), findsNothing);
  });

  testWidgets('fechar seletor não altera cliente nem carrinho', (tester) async {
    await tester.pumpWidget(_page(_Repository(), references: _searchReferences()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Selecionar cliente'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Fechar'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum cliente selecionado.'), findsOneWidget);

    await tester.tap(find.text('Adicionar produto'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Fechar'));
    await tester.pumpAndSettle();
    expect(find.text('Carrinho vazio'), findsOneWidget);
  });

  testWidgets('seletores não causam overflow em largura compacta', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _page(
        _Repository(),
        references: _searchReferences(),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SalesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Selecionar cliente'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Fechar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adicionar produto'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('permanece sem overflow em largura compacta e texto ampliado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _page(
        _Repository(),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SalesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('bloqueia formulário sem feature ou permissão', (tester) async {
    await tester.pumpWidget(_page(_Repository(), allowed: false));
    await tester.pumpAndSettle();
    expect(find.text('Vendas indisponíveis'), findsOneWidget);
    expect(find.text('Selecionar cliente'), findsNothing);
  });
}

Widget _page(
  _Repository repository, {
  bool allowed = true,
  SalesDraftSeed? references,
  Widget home = const SalesPage(),
}) {
  final useCase = RegisterSaleUseCase(
    repository: repository,
    idGenerator: () => '11111111-2222-4333-8444-555555555555',
    clock: () => DateTime(2026, 9, 11, 9),
  );
  return ProviderScope(
    overrides: [
      shellProfileProvider.overrideWithValue(_profile(allowed: allowed)),
      salesDraftSeedProvider.overrideWith(
        (ref) => Stream.value(
          references ?? SalesDraftSeed(
            clients: const [
              SaleClientOption(
                id: '201',
                name: 'Cliente Real',
                code: 'CLI-201',
                city: 'Belém - PA',
              ),
            ],
            products: const [
              SaleProductOption(
                id: '101',
                name: 'Produto Drift',
                sku: 'SKU-101',
                price: null,
              ),
            ],
          ),
        ),
      ),
      persistedSalesProvider.overrideWith((ref) => Stream.value(const [])),
      registerSaleUseCaseProvider.overrideWithValue(useCase),
      salesTimeZoneProvider.overrideWithValue('America/Belem'),
      contextSyncEngineProvider.overrideWithValue(null),
    ],
    child: MaterialApp(theme: AppTheme.light, home: home),
  );
}

SalesDraftSeed _searchReferences() => SalesDraftSeed(
  clients: const [
    SaleClientOption(
      id: '201',
      name: 'Cliente Real',
      code: 'CLI-201',
      city: 'Belém - PA',
    ),
    SaleClientOption(
      id: '202',
      name: 'Cliente Exemplo',
      code: 'CLI-202',
      city: 'Campinas - SP',
    ),
  ],
  products: const [
    SaleProductOption(
      id: '101',
      name: 'Produto Drift',
      sku: 'SKU-101',
      price: null,
    ),
    SaleProductOption(
      id: '102',
      name: 'Produto Exemplo',
      sku: 'SKU-102',
      price: null,
    ),
  ],
);

ShellProfile _profile({bool allowed = true}) => ShellProfile(
  userName: 'Maria',
  userEmail: 'maria@example.test',
  tenantName: 'Arara',
  tenantSlug: 'arara',
  features: allowed ? const {'sales'} : const {'catalog'},
  permissions: {'sales_create': allowed, 'view_financial_metrics': false},
);

class _Repository implements SalesRepository {
  SaleDraft? draft;
  @override
  Future<String> register({
    required String localSaleId,
    required String clientRequestId,
    required SaleDraft draft,
    required DateTime createdAt,
  }) async {
    this.draft = draft;
    return localSaleId;
  }
}
