import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/sync/sync_error_mapper.dart';

class RemoteDashboardSnapshot {
  RemoteDashboardSnapshot(Map<String, dynamic> body)
      : data = _map(body['data']), webDashboardUrl = _text(body['web_dashboard_url']), revision = _text(_map(body['meta'])['revision']), generatedAt = _date(_map(body['meta'])['generated_at']), period = _text(_map(body['meta'])['period']), referenceDate = _text(_map(body['meta'])['reference_date']) {
    if (data['can_view_financial'] is! bool) throw const FormatException('can_view_financial ausente.');
  }
  final Map<String, dynamic> data; final String webDashboardUrl, revision, period, referenceDate; final DateTime generatedAt;
  bool get canViewFinancial => data['can_view_financial'] as bool;
  String get payloadJson => jsonEncode(data);
}
class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this._api); final ApiClient _api; CancelToken? _pending;
  Future<RemoteDashboardSnapshot> fetch({required String groupBy, required String goalMonth, required int page}) async {
    final token = CancelToken(); _pending = token;
    try { final response = await _api.get<Map<String, dynamic>>('/api/mobile/dashboard', queryParameters: {'group_by': groupBy, 'goal_month': goalMonth, 'page': page}, cancelToken: token); if (response.data == null) throw const FormatException('Resposta do painel vazia.'); return RemoteDashboardSnapshot(response.data!); } on Object catch (error) { throw syncExceptionFrom(error); } finally { if (identical(_pending, token)) _pending = null; }
  }
  void cancelPendingRequest() => _pending?.cancel('sync stopped');
}
Map<String, dynamic> _map(Object? value) => value is Map<String, dynamic> ? value : throw const FormatException('Objeto esperado.');
String _text(Object? value) => value is String && value.isNotEmpty ? value : throw const FormatException('Texto esperado.');
DateTime _date(Object? value) { final result = value is String ? DateTime.tryParse(value) : null; return result?.toUtc() ?? (throw const FormatException('Data inválida.')); }
