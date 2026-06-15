import '../../domain/repositories/dashboard_repository.dart';
import '../local/dashboard_fixture.dart';

class FixtureDashboardRepository implements DashboardRepository {
  const FixtureDashboardRepository();

  @override
  Future<DashboardLoadResult> load() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final overview = buildDashboardFixture();
    if (overview.kpis.isEmpty &&
        overview.lowStockAlerts.isEmpty &&
        overview.recentMovements.isEmpty) {
      return const DashboardLoadResult.empty(
        'Ainda não há dados operacionais suficientes para este recorte.',
      );
    }
    return DashboardLoadResult.ready(overview);
  }
}
