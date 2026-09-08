import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/reactive_dashboard_repository.dart';
import '../local/dashboard_local_store.dart';

class DriftDashboardRepository implements ReactiveDashboardRepository {
  DriftDashboardRepository(this.local, {required this.canViewFinancial});

  final DashboardLocalStore local;
  final bool canViewFinancial;

  @override
  Future<DashboardLoadResult> load() => watch().first;

  @override
  Stream<DashboardLoadResult> watch() => local.watch().map((overview) {
    if (overview == null) {
      return const DashboardLoadResult.empty('O painel ainda não foi sincronizado neste dispositivo.');
    }
    if (!canViewFinancial && overview.canViewFinancial) {
      return const DashboardLoadResult.restricted(
        'Atualize o painel para carregar os dados permitidos ao seu perfil.',
      );
    }
    return DashboardLoadResult.ready(overview);
  });
}
