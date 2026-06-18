class OperationalContext {
  OperationalContext({
    required this.userName,
    required this.userEmail,
    required this.tenantName,
    required this.tenantSlug,
    required Set<String> features,
    required Map<String, bool> permissions,
  }) : features = Set.unmodifiable(features),
       permissions = Map.unmodifiable(permissions);

  final String userName;
  final String userEmail;
  final String tenantName;
  final String tenantSlug;
  final Set<String> features;
  final Map<String, bool> permissions;

  bool isFeatureEnabled(String feature) => features.contains(feature);

  bool permissionGranted(String permission) => permissions[permission] ?? false;
}
