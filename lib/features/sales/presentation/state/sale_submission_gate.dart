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

  SaleSubmissionAttempt? attempt(LocalContext? context) => _attempts[context];

  bool begin(LocalContext? context, String id) {
    if (_attempts.containsKey(context)) return false;
    _attempts[context] = SaleSubmissionAttempt(id);
    notifyListeners();
    return true;
  }

  void uncertain(LocalContext? context, String id) {
    final current = _attempts[context];
    if (current?.id != id) return;
    current!.status = SaleSubmissionStatus.uncertain;
    notifyListeners();
  }

  void finish(LocalContext? context, String id) {
    if (_attempts[context]?.id != id) return;
    _attempts.remove(context);
    notifyListeners();
  }
}
