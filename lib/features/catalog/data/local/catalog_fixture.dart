import '../../domain/entities/catalog_product.dart';

List<CatalogProduct> buildCatalogFixture() {
  return const [
    CatalogProduct(
      id: 'prod-1',
      name: 'Capacete Trail Pro',
      sku: 'SKU-TRAIL-001',
      brand: 'Arara Motion',
      stockQuantity: 3,
      stockStatus: CatalogStockStatus.low,
      isAvailableForSale: true,
      updatedAtLabel: '12 jun, 09:10',
      price: null,
      categoryName: 'Proteção',
    ),
    CatalogProduct(
      id: 'prod-2',
      name: 'Kit Sinalização LED',
      sku: 'SKU-LED-443',
      brand: 'Visio',
      stockQuantity: 18,
      stockStatus: CatalogStockStatus.available,
      isAvailableForSale: true,
      updatedAtLabel: '12 jun, 08:42',
      price: 49.90,
      categoryName: 'Elétrica',
    ),
    CatalogProduct(
      id: 'prod-3',
      name: 'Luva Carbon Flex',
      sku: 'SKU-LUVA-077',
      brand: 'Arara Motion',
      stockQuantity: 0,
      stockStatus: CatalogStockStatus.out,
      isAvailableForSale: false,
      updatedAtLabel: '11 jun, 18:00',
      price: null,
      categoryName: 'Proteção',
    ),
    CatalogProduct(
      id: 'prod-4',
      name: 'Suporte Veicular Max',
      sku: 'SKU-SUP-220',
      brand: 'RoadLine',
      stockQuantity: 7,
      stockStatus: CatalogStockStatus.available,
      isAvailableForSale: true,
      updatedAtLabel: '11 jun, 14:20',
      price: 89.90,
      categoryName: 'Acessórios',
    ),
  ];
}
