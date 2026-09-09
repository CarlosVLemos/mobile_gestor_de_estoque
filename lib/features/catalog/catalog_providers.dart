import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/use_cases/load_catalog_use_case.dart';
import '../../app/local_context_lifecycle.dart';
import 'data/repositories/drift_catalog_repository.dart';
import 'domain/repositories/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final access = ref.watch(operationalReadAccessProvider);
  if (database == null) throw StateError('Banco local não aberto.');
  return DriftCatalogRepository(
    database,
    hasCatalogFeature: access?.hasCatalogFeature == true,
    canViewProducts: access?.canViewProducts == true,
    canViewFinancialMetrics: access?.canViewFinancialMetrics == true,
  );
});

final loadCatalogUseCaseProvider = Provider<LoadCatalogUseCase>((ref) {
  return LoadCatalogUseCase(ref.watch(catalogRepositoryProvider));
});
