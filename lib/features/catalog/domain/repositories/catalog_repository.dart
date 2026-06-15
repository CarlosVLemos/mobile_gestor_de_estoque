import '../entities/catalog_product.dart';
import '../value_objects/catalog_query.dart';

enum CatalogRestrictionKind { permission, featureDisabled }

enum CatalogLoadStatus {
  ready,
  empty,
  restricted,
  offline,
  failure,
  invalidFilter,
  rateLimited,
}

class CatalogLoadResult {
  const CatalogLoadResult._({
    required this.status,
    this.items = const [],
    this.categories = const [],
    this.message,
    this.restrictionKind,
  });

  const CatalogLoadResult.ready({
    required List<CatalogProduct> items,
    required List<String> categories,
  }) : this._(
         status: CatalogLoadStatus.ready,
         items: items,
         categories: categories,
       );

  const CatalogLoadResult.empty({
    required String message,
    required List<String> categories,
  }) : this._(
         status: CatalogLoadStatus.empty,
         message: message,
         categories: categories,
       );

  const CatalogLoadResult.restricted({
    required String message,
    required CatalogRestrictionKind kind,
    required List<String> categories,
  }) : this._(
         status: CatalogLoadStatus.restricted,
         message: message,
         restrictionKind: kind,
         categories: categories,
       );

  const CatalogLoadResult.offline({
    required String message,
    required List<CatalogProduct> items,
    required List<String> categories,
  }) : this._(
         status: CatalogLoadStatus.offline,
         message: message,
         items: items,
         categories: categories,
       );

  const CatalogLoadResult.failure({
    required String message,
    required List<CatalogProduct> items,
    required List<String> categories,
  }) : this._(
         status: CatalogLoadStatus.failure,
         message: message,
         items: items,
         categories: categories,
       );

  const CatalogLoadResult.invalidFilter({
    required String message,
    required List<String> categories,
  }) : this._(
         status: CatalogLoadStatus.invalidFilter,
         message: message,
         categories: categories,
       );

  const CatalogLoadResult.rateLimited({
    required String message,
    required List<CatalogProduct> items,
    required List<String> categories,
  }) : this._(
         status: CatalogLoadStatus.rateLimited,
         message: message,
         items: items,
         categories: categories,
       );

  final CatalogLoadStatus status;
  final List<CatalogProduct> items;
  final List<String> categories;
  final String? message;
  final CatalogRestrictionKind? restrictionKind;
}

abstract class CatalogRepository {
  Future<CatalogLoadResult> load(CatalogQuery query);
}
