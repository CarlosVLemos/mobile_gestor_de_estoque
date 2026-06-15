class DashboardOverview {
  const DashboardOverview({
    required this.headerTitle,
    required this.headerMessage,
    required this.kpis,
    required this.lowStockAlerts,
    required this.recentMovements,
    required this.canViewFinancial,
    required this.webDashboardUrl,
    required this.updatedAtLabel,
  });

  final String headerTitle;
  final String headerMessage;
  final List<DashboardKpi> kpis;
  final List<DashboardStockAlert> lowStockAlerts;
  final List<DashboardMovement> recentMovements;
  final bool canViewFinancial;
  final String webDashboardUrl;
  final String updatedAtLabel;
}

class DashboardKpi {
  const DashboardKpi({
    required this.label,
    required this.value,
    this.subtitle,
    this.isCurrency = false,
    this.isRestricted = false,
    this.isHighlighted = false,
  });

  final String label;
  final String? value;
  final String? subtitle;
  final bool isCurrency;
  final bool isRestricted;
  final bool isHighlighted;
}

class DashboardStockAlert {
  const DashboardStockAlert({
    required this.productName,
    required this.stockLabel,
    required this.toneLabel,
  });

  final String productName;
  final String stockLabel;
  final String toneLabel;
}

class DashboardMovement {
  const DashboardMovement({
    required this.productName,
    required this.movementLabel,
    required this.quantityLabel,
    required this.occurredAtLabel,
  });

  final String productName;
  final String movementLabel;
  final String quantityLabel;
  final String occurredAtLabel;
}
