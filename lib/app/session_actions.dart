import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';

final sessionActionsProvider = Provider<SessionActions>((ref) {
  return SessionActions(
    () => ref.read(authControllerProvider.notifier).logout(),
  );
});

class SessionActions {
  const SessionActions(this.logout);
  final Future<void> Function() logout;
}
