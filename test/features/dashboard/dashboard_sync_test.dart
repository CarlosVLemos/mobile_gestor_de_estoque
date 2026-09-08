import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_lease_store.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_exception.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';
import 'package:gestor_de_estoque/core/sync/sync_state.dart';
import 'package:gestor_de_estoque/features/dashboard/data/local/dashboard_local_store.dart';
import 'package:gestor_de_estoque/features/dashboard/data/remote/dashboard_remote_data_source.dart';
import 'package:gestor_de_estoque/features/dashboard/data/repositories/drift_dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/data/sync/dashboard_sync_collection.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/entities/dashboard_overview.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Dublê deliberado: não documenta nem simula campos internos do backend.
class _Decoder implements DashboardRemoteDecoder {
  DashboardOverview overview = _overview('Primeiro', alerts: true);

  @override
  DashboardOverview decode(Map<String, dynamic> body) => overview;
}

DashboardOverview _overview(String label, {bool alerts = false, bool financial = false}) => DashboardOverview(
  kpis: [DashboardKpi(label: label, value: financial ? '10.00' : null, isCurrency: true, isRestricted: !financial)],
  lowStockAlerts: alerts ? const [DashboardStockAlert(productName: 'Produto', stockLabel: '0', toneLabel: 'Crítico')] : [],
  recentMovements: const [],
  stockLevelChart: const [],
  operationalGoalChart: const DashboardOperationalGoalChart(periodLabel: 'Setembro', targetLabel: 'Restrito', currentLabel: 'Restrito', progress: 0),
  canViewFinancial: financial,
  webDashboardUrl: 'https://example.test/painel',
  updatedAtLabel: 'Dados locais',
);

void main() {
  late AppDatabase database;
  late DashboardLocalStore local;
  late Dio dio;
  late SyncEngine engine;
  late _Decoder decoder;
  bool offline = false;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    local = DashboardLocalStore(database);
    decoder = _Decoder();
    offline = false;
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      expect(options.path, '/api/mobile/dashboard');
      expect(options.queryParameters, isEmpty);
      if (offline) {
        handler.reject(DioException(requestOptions: options, type: DioExceptionType.connectionError));
      } else {
        handler.resolve(Response(requestOptions: options, data: {
          'dashboard': {'can_view_financial': false},
          'web_dashboard_url': 'https://example.test/painel',
        }));
      }
    }));
    engine = SyncEngine(
      collections: [DashboardSyncCollection(local: local, remote: DashboardRemoteDataSource(ApiClient(dio), decoder))],
      lock: SyncLock(),
      leaseStore: DriftSyncLeaseStore(database: database, ttl: const Duration(minutes: 2)),
    );
  });

  tearDown(() async {
    await engine.dispose();
    dio.close();
    await database.close();
  });

  test('snapshot substitui KPIs e remove alertas antigos, preservando nulos', () async {
    expect(await engine.sync(), SyncOutcome.succeeded);
    expect((await local.read())!.kpis.single.value, isNull);
    expect((await local.read())!.lowStockAlerts, hasLength(1));
    decoder.overview = _overview('Novo');
    expect(await engine.sync(), SyncOutcome.succeeded);
    final stored = (await local.read())!;
    expect(stored.kpis.single.label, 'Novo');
    expect(stored.lowStockAlerts, isEmpty);
    expect(stored.operationalGoalChart.periodLabel, 'Setembro');
  });

  test('falha remota mantém snapshot anterior disponível pelo repositório', () async {
    await engine.sync();
    offline = true;
    expect(await engine.sync(), SyncOutcome.failed);
    expect(engine.state.failureKind, SyncFailureKind.offline);
    final result = await DriftDashboardRepository(local, canViewFinancial: false).load();
    expect(result.status, DashboardLoadStatus.ready);
    expect(result.overview!.kpis.single.label, 'Primeiro');
  });

  test('falha ao salvar checkpoint reverte substituição inteira do painel', () async {
    await engine.sync();
    await database.customStatement('''
      CREATE TRIGGER reject_dashboard BEFORE UPDATE ON sync_checkpoints
      BEGIN SELECT RAISE(ABORT, 'checkpoint failure'); END
    ''');
    decoder.overview = _overview('Não deve persistir');
    expect(await engine.sync(), SyncOutcome.failed);
    expect((await local.read())!.kpis.single.label, 'Primeiro');
    expect((await local.read())!.lowStockAlerts, hasLength(1));
  });

  test('decoder que contraria permissão remota não grava dados financeiros', () async {
    decoder.overview = _overview('Financeiro', financial: true);
    expect(await engine.sync(), SyncOutcome.failed);
    expect(engine.state.failureKind, SyncFailureKind.invalidData);
    expect(await local.read(), isNull);
  });

  test('perfil sem financeiro não lê snapshot antigo com financeiro', () async {
    await local.replace(_overview('Financeiro', financial: true));
    final result = await DriftDashboardRepository(local, canViewFinancial: false).load();
    expect(result.status, DashboardLoadStatus.restricted);
    expect(result.overview, isNull);
  });

  test('stream publica snapshot novo após commit', () async {
    final updated = Completer<void>();
    final subscription = local.watch().listen((overview) {
      if (overview?.kpis.single.label == 'Primeiro' && !updated.isCompleted) updated.complete();
    });
    try {
      await engine.sync();
      await updated.future;
    } finally {
      await subscription.cancel();
    }
  });
}
