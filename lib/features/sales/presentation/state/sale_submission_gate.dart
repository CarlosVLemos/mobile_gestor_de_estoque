import 'package:flutter/foundation.dart';

import '../../../../core/database/local_context.dart';

enum SaleSubmissionStatus { idle, registering, uncertain }

class SaleSubmissionAttempt {
  SaleSubmissionAttempt(this.id);

  final String id;
  SaleSubmissionStatus status = SaleSubmissionStatus.registering;
}

/// Survives controller invalidation and keeps each account's attempt isolated.
class SaleSubmissionGate extends ChangeNotifier {
  final Map<LocalContext?, SaleSubmissionAttempt> _attempts = {};
  bool _disposed = false;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  SaleSubmissionAttempt? attempt(LocalContext? context) => _attempts[context];

  bool begin(LocalContext? context, String id) {
    if (_attempts.containsKey(context)) return false;
    _attempts[context] = SaleSubmissionAttempt(id);
    _notify();
    return true;
  }

  void uncertain(LocalContext? context, String id) {
    final current = _attempts[context];
    if (current?.id != id) return;
    current!.status = SaleSubmissionStatus.uncertain;
    _notify();
  }

  void finish(LocalContext? context, String id) {
    if (_attempts[context]?.id != id) return;
    _attempts.remove(context);
    _notify();
  }
}
