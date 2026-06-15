import '../entities/operational_context.dart';

enum OperationalContextLoadStatus { ready, restricted, failure }

class OperationalContextLoadResult {
  const OperationalContextLoadResult._({
    required this.status,
    this.context,
    this.message,
  });

  const OperationalContextLoadResult.ready(OperationalContext context)
    : this._(status: OperationalContextLoadStatus.ready, context: context);

  const OperationalContextLoadResult.restricted(String message)
    : this._(status: OperationalContextLoadStatus.restricted, message: message);

  const OperationalContextLoadResult.failure(String message)
    : this._(status: OperationalContextLoadStatus.failure, message: message);

  final OperationalContextLoadStatus status;
  final OperationalContext? context;
  final String? message;
}

abstract class OperationalContextRepository {
  Future<OperationalContextLoadResult> load();
}
