import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';

final shellDisplayNameControllerProvider =
    NotifierProvider<ShellDisplayNameController, String?>(
      ShellDisplayNameController.new,
    );

final shellProfileProvider = Provider<ShellProfile>((ref) {
  final localDisplayName = ref.watch(shellDisplayNameControllerProvider);
  final session = ref.watch(authControllerProvider).session;

  return ShellProfile(
    userName: localDisplayName?.trim().isNotEmpty == true
        ? localDisplayName!.trim()
        : session?.userName ?? '',
    userEmail: session?.email ?? '',
    tenantName: session?.tenantName ?? '',
    tenantSlug: session?.tenantSlug ?? '',
    features: session?.features ?? const {},
    permissions: session?.permissions ?? const {},
  );
});

class ShellDisplayNameController extends Notifier<String?> {
  @override
  String? build() => null;

  void updateName(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return;
    }
    state = normalized;
  }
}

class ShellProfile {
  ShellProfile({
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
}
