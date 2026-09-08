import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/state/auth_state.dart';

final sessionActionsProvider = Provider<SessionActions>((ref) {
  return SessionActions(
    ({bool confirmPendingOutbox = false}) => ref
        .read(authControllerProvider.notifier)
        .logout(confirmPendingOutbox: confirmPendingOutbox),
  );
});

class SessionActions {
  const SessionActions(this.logout);
  final Future<LogoutAttempt> Function({bool confirmPendingOutbox}) logout;
}
