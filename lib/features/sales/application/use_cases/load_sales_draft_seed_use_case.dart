import '../../domain/entities/sale_reference_data.dart';
import '../../domain/repositories/sales_draft_repository.dart';

class LoadSalesDraftSeedUseCase {
  const LoadSalesDraftSeedUseCase(this._repository);

  final SalesDraftRepository _repository;

  SalesDraftSeed call() {
    return _repository.loadDraftSeed();
  }

  Stream<SalesDraftSeed> watch() {
    final repository = _repository;
    if (repository is! ReactiveSalesDraftRepository) {
      return Stream.value(repository.loadDraftSeed());
    }
    return repository.watchDraftSeed();
  }
}
