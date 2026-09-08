class CatalogReadAccess {
  const CatalogReadAccess({
    required this.featureEnabled,
    required this.canViewProducts,
    required this.canViewFinancial,
  });

  final bool featureEnabled;
  final bool canViewProducts;
  final bool canViewFinancial;
}
