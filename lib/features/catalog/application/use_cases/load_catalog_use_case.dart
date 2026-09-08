import '../../domain/repositories/reactive_catalog_repository.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/value_objects/catalog_query.dart';

class LoadCatalogUseCase {
  const LoadCatalogUseCase(this._repository);

  final CatalogRepository _repository;

  Future<CatalogLoadResult> call(CatalogQuery query) {
    return _repository.load(query);
  }

  Stream<CatalogLoadResult> watch(CatalogQuery query) {
    final repository = _repository;
    return repository is ReactiveCatalogRepository
        ? repository.watch(query)
        : Stream.fromFuture(repository.load(query));
  }
}
