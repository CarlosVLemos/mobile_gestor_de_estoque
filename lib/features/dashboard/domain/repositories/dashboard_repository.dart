import '../entities/dashboard_overview.dart';

enum DashboardLoadStatus { ready, empty, restricted, offline, failure }

class DashboardLoadResult {
  const DashboardLoadResult._({
    required this.status,
    this.overview,
    this.message,
  });

  const DashboardLoadResult.ready(DashboardOverview overview)
    : this._(status: DashboardLoadStatus.ready, overview: overview);

  const DashboardLoadResult.empty(String message)
    : this._(status: DashboardLoadStatus.empty, message: message);

  const DashboardLoadResult.restricted(String message)
    : this._(status: DashboardLoadStatus.restricted, message: message);

  const DashboardLoadResult.offline(
    String message, {
    DashboardOverview? overview,
  }) : this._(
         status: DashboardLoadStatus.offline,
         message: message,
         overview: overview,
       );

  const DashboardLoadResult.failure(
    String message, {
    DashboardOverview? overview,
  }) : this._(
         status: DashboardLoadStatus.failure,
         message: message,
         overview: overview,
       );

  final DashboardLoadStatus status;
  final DashboardOverview? overview;
  final String? message;
}

abstract class DashboardRepository {
  Future<DashboardLoadResult> load();
}
