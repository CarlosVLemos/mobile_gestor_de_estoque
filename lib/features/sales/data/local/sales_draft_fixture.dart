import '../../domain/entities/sale_reference_data.dart';

SalesDraftSeed buildSalesDraftSeedFixture() {
  return const SalesDraftSeed(
    clients: [
      SaleClientOption(
        id: 'client-1',
        name: 'Loja Horizonte',
        code: 'CL-204',
        city: 'Campinas',
      ),
      SaleClientOption(
        id: 'client-2',
        name: 'Moto Peças Aurora',
        code: 'CL-311',
        city: 'Jundiaí',
      ),
      SaleClientOption(
        id: 'client-3',
        name: 'Ponto Rota Sul',
        code: 'CL-118',
        city: 'Sorocaba',
      ),
    ],
    products: [
      SaleProductOption(
        id: 'prod-1',
        name: 'Capacete Trail Pro',
        sku: 'SKU-TRAIL-001',
        price: null,
      ),
      SaleProductOption(
        id: 'prod-2',
        name: 'Kit Sinalização LED',
        sku: 'SKU-LED-443',
        price: 49.90,
      ),
      SaleProductOption(
        id: 'prod-4',
        name: 'Suporte Veicular Max',
        sku: 'SKU-SUP-220',
        price: 89.90,
      ),
    ],
  );
}
