import 'package:drift/native.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/local_context_lifecycle.dart';
import 'package:gestor_de_estoque/core/config/app_mode.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';

void main() {
  late AppDatabase database;
  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('normal compõe produtos, clientes e dashboard reais', () {
    final collections = buildContextSyncCollections(
      mode: AppMode.normal,
      database: database,
      access: const OperationalReadAccess(
        hasCatalogFeature: true,
        canViewProducts: true,
        canViewFinancialMetrics: true,
        hasSalesFeature: true,
        canCreateSales: true,
      ),
      api: ApiClient(Dio()),
      accessToken: 'real-token',
      scopeKey: 'day:2026-09:1',
      goalMonth: '2026-09',
    );
    expect(collections.map((item) => item.name), [
      'products',
      'clients',
      'dashboard:day:2026-09:1',
    ]);
  });

  test('demo compõe somente seed local e não exige API ou token', () {
    final collections = buildContextSyncCollections(
      mode: AppMode.demo,
      database: database,
      access: null,
      api: null,
      accessToken: null,
      scopeKey: 'ignored',
      goalMonth: 'ignored',
    );
    expect(collections.single.name, 'demo_seed_v5');
  });

  test('normal falha fechado sem API/token em vez de usar demo', () {
    expect(
      () => buildContextSyncCollections(
        mode: AppMode.normal,
        database: database,
        access: null,
        api: null,
        accessToken: null,
        scopeKey: 'scope',
        goalMonth: '2026-09',
      ),
      throwsStateError,
    );
  });
}
