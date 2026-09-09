import 'dart:convert';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DriftDashboardRepository implements ReactiveDashboardRepository {
  DriftDashboardRepository(
    this._database,
    this.scopeKey, {
    required this.canViewFinancialMetrics,
  });

  final AppDatabase _database;
  final String scopeKey;
  final bool canViewFinancialMetrics;

  @override
  Future<DashboardLoadResult> load() => watch().first;

  @override
  Stream<DashboardLoadResult> watch() =>
      _database.watchDashboardSnapshot(scopeKey).map((snapshot) {
        if (snapshot == null) {
          return const DashboardLoadResult.empty(
            'O painel ainda não foi sincronizado neste dispositivo.',
          );
        }
        try {
          return DashboardLoadResult.ready(_decode(snapshot));
        } on FormatException {
          return const DashboardLoadResult.failure(
            'O snapshot local do painel é inválido.',
          );
        }
      });

  DashboardOverview _decode(StoredDashboardSnapshot row) {
    final data = _map(jsonDecode(row.payloadJson));
    final canViewFinancial =
        canViewFinancialMetrics && row.canViewFinancial;
    return DashboardOverview(
      kpis: _decodeKpis(_map(data['kpis']), canViewFinancial),
      lowStockAlerts: _decodeAlerts(data['low_stock_alert']),
      recentMovements: _decodeMovements(data['recent_movements']),
      stockLevelChart: _decodeStockLevels(data['stock_level_chart']),
      operationalGoalChart: _decodeGoal(
        data['operational_goal_chart'],
        canViewFinancial: canViewFinancial,
        periodLabel: row.period,
      ),
      canViewFinancial: canViewFinancial,
      webDashboardUrl: row.webDashboardUrl,
      updatedAtLabel: row.generatedAt.toLocal().toString(),
    );
  }
}

List<DashboardKpi> _decodeKpis(
  Map<String, dynamic> values,
  bool canViewFinancial,
) => [
  for (final entry in values.entries)
    DashboardKpi(
      label: _label(entry.key),
      value: _isFinancialMetric(entry.key) && !canViewFinancial
          ? null
          : _metricValue(entry.value, isCents: entry.key.endsWith('_cents')),
      isCurrency: _isFinancialMetric(entry.key),
      isRestricted: _isFinancialMetric(entry.key) && !canViewFinancial,
    ),
];

List<DashboardStockAlert> _decodeAlerts(Object? source) => [
  for (final item in _records(source))
    DashboardStockAlert(
      productName: _firstText(item, const ['product_name', 'name', 'product']),
      stockLabel: _firstText(item, const ['stock_label', 'stock_quantity', 'quantity']),
      toneLabel: _firstText(item, const ['tone_label', 'status', 'severity']),
    ),
];

List<DashboardMovement> _decodeMovements(Object? source) => [
  for (final item in _records(source))
    DashboardMovement(
      productName: _firstText(item, const ['product_name', 'product', 'name']),
      movementLabel: _firstText(item, const ['movement_label', 'type', 'description']),
      quantityLabel: _firstText(item, const ['quantity_label', 'quantity']),
      occurredAtLabel: _firstText(item, const ['occurred_at', 'created_at', 'date']),
    ),
];

List<DashboardStockLevelPoint> _decodeStockLevels(Object? source) => [
  for (final item in _records(source))
    DashboardStockLevelPoint(
      label: _firstText(item, const ['category', 'label']),
      value: _integer(item['total_quantity'] ?? item['value']),
      toneLabel: _firstText(item, const ['tone_label', 'status']),
    ),
];

DashboardOperationalGoalChart _decodeGoal(
  Object? source, {
  required bool canViewFinancial,
  required String periodLabel,
}) {
  final chart = _map(source);
  if (!canViewFinancial || chart['configured'] != true) {
    return DashboardOperationalGoalChart(
      periodLabel: periodLabel,
      targetLabel: '—',
      currentLabel: '—',
      progress: 0,
    );
  }
  final summary = _map(chart['summary']);
  return DashboardOperationalGoalChart(
    periodLabel: periodLabel,
    targetLabel: _moneyFromCents(summary['target_cents']),
    currentLabel: _moneyFromCents(summary['actual_accumulated_cents']),
    progress: (_number(summary['progress_percent']) / 100)
        .clamp(0.0, 1.0)
        .toDouble(),
  );
}

List<Map<String, dynamic>> _records(Object? source) {
  if (source is List) return source.map(_map).toList(growable: false);
  final map = _map(source);
  final data = map['data'];
  if (data is List) return data.map(_map).toList(growable: false);
  return map.isEmpty ? const [] : [map];
}

Map<String, dynamic> _map(Object? value) =>
    value is Map<String, dynamic> ? value : const {};

String? _metricValue(Object? value, {required bool isCents}) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) {
    final nested = value['value'] ?? value['formatted'] ?? value['total'];
    return _metricValue(nested, isCents: isCents);
  }
  if (isCents && value is num) return (value / 100).toString();
  return value.toString();
}

String _firstText(Map<String, dynamic> value, List<String> keys) {
  for (final key in keys) {
    final candidate = value[key];
    if (candidate is String && candidate.isNotEmpty) return candidate;
    if (candidate is num) return candidate.toString();
    if (candidate is Map<String, dynamic>) {
      final name = candidate['name'];
      if (name is String && name.isNotEmpty) return name;
    }
  }
  return '—';
}

String _label(String value) => value
    .split('_')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

bool _isFinancialMetric(String key) =>
    key.endsWith('_cents') ||
    key.startsWith('revenue') ||
    key.startsWith('average_ticket') ||
    key.startsWith('sold_amount');

int _integer(Object? value) => value is int
    ? value
    : value is num
    ? value.toInt()
    : 0;

double _number(Object? value) => value is num && value.isFinite
    ? value.toDouble()
    : 0;

String _moneyFromCents(Object? value) => value is num
    ? 'R\$ ${(value / 100).toStringAsFixed(2)}'
    : '—';
