import '../../domain/repositories/operational_context_repository.dart';

class GetOperationalContextUseCase {
  const GetOperationalContextUseCase(this._repository);

  final OperationalContextRepository _repository;

  Future<OperationalContextLoadResult> call() {
    return _repository.load();
  }
}
