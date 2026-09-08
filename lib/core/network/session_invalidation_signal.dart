import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Neutral boundary between transport and the application session lifecycle.
class SessionInvalidationSignal extends ChangeNotifier {
  void notifyInvalidSession() => notifyListeners();
}

final sessionInvalidationSignalProvider = Provider<SessionInvalidationSignal>((
  ref,
) {
  final signal = SessionInvalidationSignal();
  ref.onDispose(signal.dispose);
  return signal;
});
