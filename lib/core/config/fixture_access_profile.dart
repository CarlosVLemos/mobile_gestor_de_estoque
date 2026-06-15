class FixtureAccessProfile {
  const FixtureAccessProfile({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.tenantId,
    required this.tenantName,
    required this.tenantSlug,
    required this.features,
    required this.permissions,
  });

  final String userId;
  final String userName;
  final String userEmail;
  final String tenantId;
  final String tenantName;
  final String tenantSlug;
  final Set<String> features;
  final Map<String, bool> permissions;

  bool get hasCatalogFeature => features.contains('catalog');

  bool get canViewProducts => permissions['products_view'] ?? false;

  bool get canCreateSales => permissions['sales_create'] ?? false;

  bool get canViewReports => permissions['reports_view'] ?? false;

  bool get canViewFinancialMetrics =>
      permissions['view_financial_metrics'] ?? false;
}

const appFixtureAccessProfile = FixtureAccessProfile(
  userId: '5b548422-4d1b-48f1-83dd-7d06b44c0012',
  userName: 'Maria Oliveira',
  userEmail: 'maria@arara-gastos.test',
  tenantId: 'a8b6a1df-bb70-4e8c-b6ff-1fe77e3d0024',
  tenantName: 'Arara Centro Logistico',
  tenantSlug: 'arara-centro-logistico',
  features: {'catalog', 'sales'},
  permissions: {
    'products_view': true,
    'sales_create': true,
    'reports_view': false,
    'view_financial_metrics': false,
  },
);
