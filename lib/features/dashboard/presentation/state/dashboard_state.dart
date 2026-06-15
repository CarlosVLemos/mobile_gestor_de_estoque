import '../../../../shared/ui_states/view_status.dart';
import '../../domain/entities/dashboard_overview.dart';

class DashboardState {
  const DashboardState({required this.status, this.overview, this.message});

  const DashboardState.initial() : this(status: ViewStatus.initial);

  const DashboardState.loading({DashboardOverview? previous})
    : this(status: ViewStatus.loading, overview: previous);

  const DashboardState.ready(DashboardOverview overview)
    : this(status: ViewStatus.ready, overview: overview);

  const DashboardState.refreshing(DashboardOverview overview)
    : this(status: ViewStatus.refreshing, overview: overview);

  const DashboardState.empty(String message)
    : this(status: ViewStatus.empty, message: message);

  const DashboardState.restricted(String message)
    : this(status: ViewStatus.restricted, message: message);

  const DashboardState.offline(String message, {DashboardOverview? previous})
    : this(status: ViewStatus.offline, message: message, overview: previous);

  const DashboardState.failure(String message, {DashboardOverview? previous})
    : this(status: ViewStatus.failure, message: message, overview: previous);

  final ViewStatus status;
  final DashboardOverview? overview;
  final String? message;
}
