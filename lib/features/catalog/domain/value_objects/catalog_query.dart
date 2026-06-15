class CatalogQuery {
  const CatalogQuery({this.search = '', this.category});

  final String search;
  final String? category;

  CatalogQuery copyWith({
    String? search,
    String? category,
    bool clearCategory = false,
  }) {
    return CatalogQuery(
      search: search ?? this.search,
      category: clearCategory ? null : (category ?? this.category),
    );
  }
}
