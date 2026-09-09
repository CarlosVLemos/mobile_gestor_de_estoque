import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DriftDashboardRepository implements ReactiveDashboardRepository {
  DriftDashboardRepository(this._database, this.scopeKey);
  final AppDatabase _database; final String scopeKey;
  @override Future<DashboardLoadResult> load() => watch().first;
  @override Stream<DashboardLoadResult> watch() => _database.watchDashboardSnapshot(scopeKey).map((snapshot) {
    if (snapshot == null) return const DashboardLoadResult.empty('O painel ainda não foi sincronizado neste dispositivo.');
    try { return DashboardLoadResult.ready(_decode(snapshot)); } on FormatException { return const DashboardLoadResult.failure('O snapshot local do painel é inválido.'); }
  });

  DashboardOverview _decode(StoredDashboardSnapshot row) {
    final data = jsonDecode(row.payloadJson); if (data is! Map<String, dynamic>) throw const FormatException();
    final kpis = _items(data['kpis']).map((value) { final item = _map(value); return DashboardKpi(label: _text(item['label']), value: item['value']?.toString(), subtitle: item['subtitle']?.toString(), isCurrency: item['is_currency'] == true, isRestricted: item['is_restricted'] == true, isHighlighted: item['is_highlighted'] == true); }).toList();
    final alerts = _items(data['low_stock_alerts']).map((value) { final item = _map(value); return DashboardStockAlert(productName: _text(item['product_name']), stockLabel: _text(item['stock_label']), toneLabel: _text(item['tone_label'])); }).toList();
    final movements = _items(data['recent_movements']).map((value) { final item = _map(value); return DashboardMovement(productName: _text(item['product_name']), movementLabel: _text(item['movement_label']), quantityLabel: _text(item['quantity_label']), occurredAtLabel: _text(item['occurred_at_label'])); }).toList();
    final stock = _items(data['stock_level_chart']).map((value) { final item = _map(value); return DashboardStockLevelPoint(label: _text(item['label']), value: _integer(item['value']), toneLabel: _text(item['tone_label'])); }).toList();
    final goal = _map(data['operational_goal_chart']);
    return DashboardOverview(kpis: kpis, lowStockAlerts: alerts, recentMovements: movements, stockLevelChart: stock, operationalGoalChart: DashboardOperationalGoalChart(periodLabel: _text(goal['period_label']), targetLabel: _text(goal['target_label']), currentLabel: _text(goal['current_label']), progress: _number(goal['progress'])), canViewFinancial: row.canViewFinancial, webDashboardUrl: row.webDashboardUrl, updatedAtLabel: row.generatedAt.toLocal().toString());
  }
}
Map<String, dynamic> _map(Object? value) => value is Map<String, dynamic> ? value : throw const FormatException();
List<dynamic> _items(Object? value) => value is List ? value : const [];
String _text(Object? value) => value is String ? value : throw const FormatException();
int _integer(Object? value) => value is int ? value : throw const FormatException();
double _number(Object? value) => value is num && value.isFinite ? value.toDouble() : throw const FormatException();
