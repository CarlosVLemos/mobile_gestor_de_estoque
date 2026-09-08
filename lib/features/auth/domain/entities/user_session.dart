class UserSession {
  const UserSession({
    required this.userId,
    required this.userName,
    required this.email,
    required this.tenantId,
    required this.tenantName,
    required this.tenantSlug,
    required this.features,
    required this.permissions,
    required this.revision,
    required this.mustChangePassword,
  });

  final String userId;
  final String userName;
  final String email;
  final String tenantId;
  final String tenantName;
  final String tenantSlug;
  final Set<String> features;
  final Map<String, bool> permissions;
  final String revision;
  final bool mustChangePassword;
}
