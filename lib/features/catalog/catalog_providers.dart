import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/network/api_client.dart';
import '../../core/sync/sync_collection.dart';
import 'application/use_cases/load_catalog_use_case.dart';
import 'data/remote/product_remote_data_source.dart';
import 'data/repositories/drift_product_repository.dart';
import 'data/repositories/fixture_catalog_repository.dart';
import 'data/sync/product_sync_collection.dart';
import 'domain/entities/catalog_read_access.dart';
import 'domain/repositories/catalog_repository.dart';
import 'domain/value_objects/catalog_query.dart';

final catalogReadAccessProvider = Provider<CatalogReadAccess>((ref) {
  return const CatalogReadAccess(featureEnabled: false, canViewProducts: false, canViewFinancial: false);
});

final catalogSyncCollectionProvider = Provider<SyncCollection?>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final access = ref.watch(catalogReadAccessProvider);
  if (database == null || !access.featureEnabled || !access.canViewProducts) return null;
  return ProductSyncCollection(
    database: database,
    remote: ProductRemoteDataSource(ref.watch(apiClientProvider)),
  );
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  if (database != null) return DriftProductRepository(database, ref.watch(catalogReadAccessProvider));
  return const FixtureCatalogRepository();
});

final catalogProductsStreamProvider = StreamProvider.autoDispose.family<CatalogLoadResult, CatalogQuery>((ref, query) {
  return ref.watch(loadCatalogUseCaseProvider).watch(query);
});

final loadCatalogUseCaseProvider = Provider<LoadCatalogUseCase>((ref) {
  return LoadCatalogUseCase(ref.watch(catalogRepositoryProvider));
});
