import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/use_cases/load_catalog_use_case.dart';
import 'data/repositories/fixture_catalog_repository.dart';
import 'domain/repositories/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return const FixtureCatalogRepository();
});

final loadCatalogUseCaseProvider = Provider<LoadCatalogUseCase>((ref) {
  return LoadCatalogUseCase(ref.watch(catalogRepositoryProvider));
});
