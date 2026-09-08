import '../value_objects/catalog_query.dart';
import 'catalog_repository.dart';

abstract interface class ReactiveCatalogRepository implements CatalogRepository {
  Stream<CatalogLoadResult> watch(CatalogQuery query);
}
