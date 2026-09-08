import '../../../../core/network/api_client.dart';
import '../../../../core/network/sync_request.dart';
import '../../domain/entities/dashboard_overview.dart';

/// Implementação depende do contrato interno dos blocos do DashboardResource.
/// Deve mapear e mascarar TODOS os blocos financeiros antes de retornar.
abstract interface class DashboardRemoteDecoder {
  DashboardOverview decode(Map<String, dynamic> body);
}

class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this.api, this.decoder);

  final ApiClient api;
  final DashboardRemoteDecoder decoder;

  Future<DashboardOverview> fetch() => syncRequest(() async {
    final response = await api.get<Map<String, dynamic>>('/api/mobile/dashboard');
    final body = response.data;
    final dashboard = body?['dashboard'];
    if (body == null || dashboard is! Map<String, dynamic> ||
        dashboard['can_view_financial'] is! bool || body['web_dashboard_url'] is! String) {
      throw const FormatException('Envelope do painel inválido.');
    }
    final overview = decoder.decode(body);
    if (overview.canViewFinancial != dashboard['can_view_financial'] ||
        overview.webDashboardUrl != body['web_dashboard_url'] ||
        overview.operationalGoalChart.progress.isNaN ||
        !overview.operationalGoalChart.progress.isFinite ||
        overview.kpis.any((kpi) =>
            (kpi.isRestricted || (!overview.canViewFinancial && kpi.isCurrency)) &&
            kpi.value != null)) {
      throw const FormatException('Painel incompatível com restrição remota.');
    }
    return overview;
  });
}
