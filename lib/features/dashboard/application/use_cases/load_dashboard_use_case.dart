import '../../domain/repositories/reactive_dashboard_repository.dart';
import '../../domain/repositories/dashboard_repository.dart';

class LoadDashboardUseCase {
  const LoadDashboardUseCase(this._repository);

  final DashboardRepository _repository;

  Future<DashboardLoadResult> call() {
    return _repository.load();
  }

  Stream<DashboardLoadResult> watch() {
    final repository = _repository;
    return repository is ReactiveDashboardRepository
        ? repository.watch()
        : Stream.fromFuture(repository.load());
  }
}
