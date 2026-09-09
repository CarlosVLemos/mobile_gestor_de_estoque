import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/features/dashboard/data/remote/dashboard_remote_data_source.dart';
import 'package:gestor_de_estoque/features/dashboard/data/repositories/drift_dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/data/sync/dashboard_sync_collection.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';

void main() {
  late AppDatabase database;
  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('dashboard replaces only its own scope and preserves null financial fields in payload', () async {
    final collection = DashboardSyncCollection(database: database, remote: _Remote(_response), scopeKey: 'day:2026-09:1', goalMonth: '2026-09');
    await collection.commitPage(await collection.fetchPage(const SyncCheckpoint()));
    final row = await database.watchDashboardSnapshot('day:2026-09:1').first;
    expect(row!.revision, 'r-1');
    expect(row.payloadJson, contains('"value":null'));
    expect(await database.watchDashboardSnapshot('week:2026-09:1').first, isNull);
  });

  test('new revision replaces only the same scope and repository observes Drift', () async {
    final first = DashboardSyncCollection(database: database, remote: _Remote(_response), scopeKey: 'day:2026-09:1', goalMonth: '2026-09');
    await first.commitPage(await first.fetchPage(const SyncCheckpoint()));
    final next = DashboardSyncCollection(database: database, remote: _Remote(_responseWithRevision('r-2')), scopeKey: 'day:2026-09:1', goalMonth: '2026-09');
    await next.commitPage(await next.fetchPage(const SyncCheckpoint()));
    expect((await database.watchDashboardSnapshot('day:2026-09:1').first)!.revision, 'r-2');
    expect(
      (await DriftDashboardRepository(database, 'day:2026-09:1').load()).status,
      DashboardLoadStatus.ready,
    );
  });

  test('failed checkpoint write retains the prior dashboard snapshot', () async {
    final first = DashboardSyncCollection(database: database, remote: _Remote(_response), scopeKey: 'day:2026-09:1', goalMonth: '2026-09');
    await first.commitPage(await first.fetchPage(const SyncCheckpoint()));
    await database.customStatement('''
      CREATE TRIGGER reject_dashboard_checkpoint BEFORE UPDATE ON sync_collections
      BEGIN SELECT RAISE(ABORT, 'checkpoint failure'); END
    ''');
    final replacement = DashboardSyncCollection(database: database, remote: _Remote(_responseWithRevision('r-2')), scopeKey: 'day:2026-09:1', goalMonth: '2026-09');
    await expectLater(replacement.commitPage(await replacement.fetchPage(const SyncCheckpoint())), throwsA(isA<Object>()));
    expect((await database.watchDashboardSnapshot('day:2026-09:1').first)!.revision, 'r-1');
  });
}
class _Remote extends DashboardRemoteDataSource {
  _Remote(this.response) : super(ApiClient(Dio()));
  final Map<String, dynamic> response;
  @override Future<RemoteDashboardSnapshot> fetch({required String groupBy, required String goalMonth, required int page}) async => RemoteDashboardSnapshot(response);
}

final _response = _responseWithRevision('r-1');
Map<String, dynamic> _responseWithRevision(String revision) => {
  'data': {
    'can_view_financial': false,
    'kpis': {'monthly_revenue': null},
    'low_stock_alert': const [],
    'recent_movements': {'data': const [], 'meta': const {}},
    'stock_level_chart': const [],
    'operational_goal_chart': {'configured': false, 'summary': const {}, 'series': const []},
  },
  'web_dashboard_url': 'https://example.test/dashboard',
  'meta': {'revision': revision, 'generated_at': '2026-09-09T12:00:00Z', 'period': '2026-09', 'reference_date': '2026-09-09'},
};
