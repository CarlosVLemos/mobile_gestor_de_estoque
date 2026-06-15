import '../../../../shared/ui_states/view_status.dart';
import '../../domain/entities/operational_context.dart';

class OperationalContextState {
  const OperationalContextState({
    required this.status,
    this.context,
    this.message,
  });

  const OperationalContextState.loading() : this(status: ViewStatus.loading);

  const OperationalContextState.ready(OperationalContext context)
    : this(status: ViewStatus.ready, context: context);

  const OperationalContextState.restricted(String message)
    : this(status: ViewStatus.restricted, message: message);

  const OperationalContextState.failure(String message)
    : this(status: ViewStatus.failure, message: message);

  final ViewStatus status;
  final OperationalContext? context;
  final String? message;
}
