enum CatalogStockStatus { available, low, out }

class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.brand,
    required this.stockQuantity,
    required this.stockStatus,
    required this.isAvailableForSale,
    required this.updatedAtLabel,
    this.price,
    this.imageUrl,
    this.categoryName,
  });

  final String id;
  final String name;
  final String sku;
  final String brand;
  final int stockQuantity;
  final CatalogStockStatus stockStatus;
  final bool isAvailableForSale;
  final String updatedAtLabel;
  final double? price;
  final String? imageUrl;
  final String? categoryName;
}
