import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/features/dashboard/data/remote/dashboard_remote_data_source.dart';

void main() {
  test('uses only the documented dashboard scope parameters', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    late RequestOptions request;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response(requestOptions: options, data: _response));
    }));
    final result = await DashboardRemoteDataSource(
      ApiClient(dio),
      accessToken: 'test-token',
    ).fetch(groupBy: 'week', goalMonth: '2026-09', page: 2);
    expect(request.path, '/api/mobile/dashboard');
    expect(request.queryParameters, {'group_by': 'week', 'goal_month': '2026-09', 'page': 2});
    expect(request.headers['Authorization'], 'Bearer test-token');
    expect(result.revision, 'rev-1');
    expect(result.canViewFinancial, isFalse);
  });
}

final _response = {
  'data': {'can_view_financial': false, 'kpis': const []},
  'web_dashboard_url': 'https://example.test/dashboard',
  'meta': {'revision': 'rev-1', 'generated_at': '2026-09-09T12:00:00Z', 'period': '2026-09', 'reference_date': '2026-09-09'},
};
