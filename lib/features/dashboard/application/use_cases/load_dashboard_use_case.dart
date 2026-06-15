import '../../domain/repositories/dashboard_repository.dart';

class LoadDashboardUseCase {
  const LoadDashboardUseCase(this._repository);

  final DashboardRepository _repository;

  Future<DashboardLoadResult> call() {
    return _repository.load();
  }
}
