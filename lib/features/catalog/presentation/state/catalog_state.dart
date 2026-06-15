import '../../../../shared/ui_states/view_status.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/value_objects/catalog_query.dart';

class CatalogState {
  const CatalogState({
    required this.status,
    required this.query,
    this.items = const [],
    this.categories = const ['Todos'],
    this.message,
    this.restrictionKind,
  });

  const CatalogState.initial()
    : this(status: ViewStatus.initial, query: const CatalogQuery());

  CatalogState copyWith({
    ViewStatus? status,
    CatalogQuery? query,
    List<CatalogProduct>? items,
    List<String>? categories,
    String? message,
    CatalogRestrictionKind? restrictionKind,
    bool clearMessage = false,
    bool clearRestrictionKind = false,
  }) {
    return CatalogState(
      status: status ?? this.status,
      query: query ?? this.query,
      items: items ?? this.items,
      categories: categories ?? this.categories,
      message: clearMessage ? null : (message ?? this.message),
      restrictionKind: clearRestrictionKind
          ? null
          : (restrictionKind ?? this.restrictionKind),
    );
  }

  final ViewStatus status;
  final CatalogQuery query;
  final List<CatalogProduct> items;
  final List<String> categories;
  final String? message;
  final CatalogRestrictionKind? restrictionKind;
}
