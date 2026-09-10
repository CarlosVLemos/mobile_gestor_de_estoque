import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/features/settings/presentation/pages/operational_context_page.dart';
import 'package:gestor_de_estoque/features/settings/domain/entities/operational_context.dart';
import 'package:gestor_de_estoque/features/settings/settings_providers.dart';
import 'package:gestor_de_estoque/shared/widgets/tenant_context_card.dart';

void main() {
  testWidgets('contexto operacional exibe tenant, usuário e vínculo', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shellProfileProvider.overrideWithValue(_profile),
          currentOperationalContextProvider.overrideWithValue(_context),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: OperationalContextPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(TenantContextCard),
        matching: find.text('Arara Centro Logistico'),
      ),
      findsOneWidget,
    );
    expect(find.text('Arara Centro Logistico'), findsNWidgets(2));
    expect(find.text('Maria Oliveira'), findsOneWidget);
    expect(find.text('maria@arara-gastos.test'), findsOneWidget);
    expect(find.text('Vínculo da conta'), findsOneWidget);
    expect(find.text('Empresa vinculada'), findsOneWidget);
    expect(find.text('Consultar catálogo'), findsOneWidget);
    expect(find.text('Ver métricas financeiras'), findsOneWidget);
    expect(find.text('Liberado'), findsOneWidget);
    expect(find.text('Restrito'), findsNWidgets(3));
  });

  testWidgets('conta suporta 320px com textScaler 2.0', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shellProfileProvider.overrideWithValue(_profile),
          currentOperationalContextProvider.overrideWithValue(_context),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: OperationalContextPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('EMPRESA EM USO'), findsOneWidget);
  });
}

final _profile = ShellProfile(
  userName: 'Maria Oliveira',
  userEmail: 'maria@arara-gastos.test',
  tenantName: 'Arara Centro Logistico',
  tenantSlug: 'arara-centro',
  features: const {'catalog', 'sales'},
  permissions: const {'products_view': true, 'view_financial_metrics': false},
);

final _context = OperationalContext(
  userName: _profile.userName,
  userEmail: _profile.userEmail,
  tenantName: _profile.tenantName,
  tenantSlug: _profile.tenantSlug,
  features: _profile.features,
  permissions: _profile.permissions,
);
