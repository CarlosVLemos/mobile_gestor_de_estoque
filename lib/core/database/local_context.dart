/// Immutable identity used to scope every local resource for an authenticated
/// user in a tenant.
class LocalContext {
  const LocalContext({required this.userId, required this.tenantId});

  final String userId;
  final String tenantId;

  /// This name is deterministic, filesystem-safe and still visibly derived
  /// from both identifiers. It must never be used for a shared database.
  String get databaseFileName =>
      'app_database_u_${Uri.encodeComponent(userId)}_t_${Uri.encodeComponent(tenantId)}.db';

  /// Directory name for disposable files (images and temporary data).
  String get cacheDirectoryName =>
      'u_${Uri.encodeComponent(userId)}_t_${Uri.encodeComponent(tenantId)}';

  @override
  bool operator ==(Object other) =>
      other is LocalContext &&
      other.userId == userId &&
      other.tenantId == tenantId;

  @override
  int get hashCode => Object.hash(userId, tenantId);
}
