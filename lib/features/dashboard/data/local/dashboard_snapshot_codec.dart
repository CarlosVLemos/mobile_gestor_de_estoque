import 'dart:convert';

import '../../domain/entities/dashboard_overview.dart';

/// Formato privado da persistência v1, independente do contrato HTTP.
abstract final class DashboardSnapshotCodec {
  static String encodeDetails(DashboardOverview overview) => jsonEncode({
    'version': 1,
    'canViewFinancial': overview.canViewFinancial,
    'webDashboardUrl': overview.webDashboardUrl,
    'updatedAtLabel': overview.updatedAtLabel,
    'movements': overview.recentMovements.map((item) => {
      'productName': item.productName,
      'movementLabel': item.movementLabel,
      'quantityLabel': item.quantityLabel,
      'occurredAtLabel': item.occurredAtLabel,
    }).toList(),
    'stockLevels': overview.stockLevelChart.map((item) => {
      'label': item.label,
      'value': item.value,
      'toneLabel': item.toneLabel,
    }).toList(),
    'goal': {
      'periodLabel': overview.operationalGoalChart.periodLabel,
      'targetLabel': overview.operationalGoalChart.targetLabel,
      'currentLabel': overview.operationalGoalChart.currentLabel,
      'progress': overview.operationalGoalChart.progress,
    },
  });

  static DashboardOverview decodeDetails(
    String encoded,
    List<DashboardKpi> kpis,
    List<DashboardStockAlert> alerts,
  ) {
    final data = jsonDecode(encoded) as Map<String, dynamic>;
    if (data['version'] != 1) throw const FormatException('Snapshot não suportado.');
    final goal = data['goal'] as Map<String, dynamic>;
    return DashboardOverview(
      kpis: kpis,
      lowStockAlerts: alerts,
      recentMovements: (data['movements'] as List).map((item) => DashboardMovement(
        productName: item['productName'] as String,
        movementLabel: item['movementLabel'] as String,
        quantityLabel: item['quantityLabel'] as String,
        occurredAtLabel: item['occurredAtLabel'] as String,
      )).toList(),
      stockLevelChart: (data['stockLevels'] as List).map((item) => DashboardStockLevelPoint(
        label: item['label'] as String,
        value: item['value'] as int,
        toneLabel: item['toneLabel'] as String,
      )).toList(),
      operationalGoalChart: DashboardOperationalGoalChart(
        periodLabel: goal['periodLabel'] as String,
        targetLabel: goal['targetLabel'] as String,
        currentLabel: goal['currentLabel'] as String,
        progress: (goal['progress'] as num).toDouble(),
      ),
      canViewFinancial: data['canViewFinancial'] as bool,
      webDashboardUrl: data['webDashboardUrl'] as String,
      updatedAtLabel: data['updatedAtLabel'] as String,
    );
  }
}
