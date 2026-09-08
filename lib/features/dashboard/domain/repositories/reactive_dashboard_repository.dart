import 'dashboard_repository.dart';

abstract interface class ReactiveDashboardRepository implements DashboardRepository {
  Stream<DashboardLoadResult> watch();
}
