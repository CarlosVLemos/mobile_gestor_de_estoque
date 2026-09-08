import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/core/sync/sync_exception.dart';
import 'package:gestor_de_estoque/core/sync/sync_providers.dart';
import 'package:gestor_de_estoque/core/sync/sync_state.dart';
import 'package:gestor_de_estoque/features/catalog/catalog_providers.dart';
import 'package:gestor_de_estoque/features/catalog/domain/entities/catalog_product.dart';
import 'package:gestor_de_estoque/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/domain/repositories/reactive_catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';
import 'package:gestor_de_estoque/features/catalog/presentation/pages/catalog_page.dart';
import 'package:gestor_de_estoque/features/dashboard/dashboard_providers.dart';
import 'package:gestor_de_estoque/features/dashboard/data/local/dashboard_fixture.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/reactive_dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/presentation/pages/dashboard_page.dart';

class _Catalog implements ReactiveCatalogRepository {
  final changes = StreamController<CatalogLoadResult>.broadcast();
  int listeners = 0;

  CatalogLoadResult result(String name) => CatalogLoadResult.ready(
    items: [CatalogProduct(
      id: '1', name: name, sku: 'SKU-1', brand: 'Marca', stockQuantity: 0,
      stockStatus: CatalogStockStatus.out, isAvailableForSale: false, updatedAtLabel: 'Hoje',
    )], categories: const ['Todos'],
  );

  @override
  Future<CatalogLoadResult> load(CatalogQuery query) async => result('Produto local');

  @override
  Stream<CatalogLoadResult> watch(CatalogQuery query) => Stream.multi((controller) {
    listeners++;
    final subscription = changes.stream.listen(controller.add);
    controller.add(result('Produto local'));
    controller.onCancel = () async {
      listeners--;
      await subscription.cancel();
    };
  });
}

class _Dashboard implements ReactiveDashboardRepository {
  final changes = StreamController<DashboardLoadResult>.broadcast();
  int listeners = 0;

  @override
  Future<DashboardLoadResult> load() async => DashboardLoadResult.ready(buildDashboardFixture());

  @override
  Stream<DashboardLoadResult> watch() => Stream.multi((controller) {
    listeners++;
    final subscription = changes.stream.listen(controller.add);
    controller.add(DashboardLoadResult.ready(buildDashboardFixture()));
    controller.onCancel = () async {
      listeners--;
      await subscription.cancel();
    };
  });
}

void main() {
  testWidgets('catálogo reativo mantém cache em falha e descarta stream em 320px/texto 2x', (tester) async {
    final repository = _Catalog();
    final sync = StreamController<SyncState>.broadcast();
    tester.view.physicalSize = const Size(320, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(repository),
        syncStateProvider.overrideWith((ref) => sync.stream),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: const CatalogPage(),
      ),
    ));
    await tester.pumpAndSettle();
    expect(repository.listeners, 1);
    expect(find.text('Produto local'), findsOneWidget);
    expect(find.text('Preço restrito'), findsOneWidget);
    repository.changes.add(repository.result('Atualizado pelo banco'));
    await tester.pumpAndSettle();
    expect(find.text('Atualizado pelo banco'), findsOneWidget);
    sync.add(const SyncState(status: SyncStatus.failed, collection: 'products', failureKind: SyncFailureKind.offline));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sem conexão.'), findsOneWidget);
    expect(find.text('Atualizado pelo banco'), findsOneWidget);
    expect(tester.takeException(), isNull);
    // 403 não deve deixar os dados do cache visíveis.
    sync.add(const SyncState(status: SyncStatus.failed, collection: 'products', failureKind: SyncFailureKind.forbidden));
    await tester.pumpAndSettle();
    expect(find.text('Atualizado pelo banco'), findsNothing);
    expect(find.text('Seu perfil não pode consultar produtos'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(repository.listeners, 0);
    await repository.changes.close();
    await sync.close();
  });

  testWidgets('painel mantém dados durante refresh/falha e cancela stream no descarte', (tester) async {
    final repository = _Dashboard();
    final sync = StreamController<SyncState>.broadcast();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(repository),
        syncStateProvider.overrideWith((ref) => sync.stream),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const DashboardPage()),
    ));
    await tester.pumpAndSettle();
    expect(repository.listeners, 1);
    sync.add(const SyncState(status: SyncStatus.syncing, collection: 'dashboard'));
    await tester.pump();
    expect(find.text('Indicadores'), findsOneWidget);
    sync.add(const SyncState(status: SyncStatus.failed, collection: 'dashboard', failureKind: SyncFailureKind.remote));
    await tester.pumpAndSettle();
    expect(find.text('Indicadores'), findsOneWidget);
    expect(find.textContaining('A sincronização falhou.'), findsOneWidget);
    expect(find.text('Offline'), findsNothing);
    sync.add(const SyncState(status: SyncStatus.failed, collection: 'dashboard', failureKind: SyncFailureKind.unauthorized));
    await tester.pumpAndSettle();
    expect(find.text('Indicadores'), findsNothing);
    expect(find.text('Painel indisponível para este perfil'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(repository.listeners, 0);
    await repository.changes.close();
    await sync.close();
  });
}
