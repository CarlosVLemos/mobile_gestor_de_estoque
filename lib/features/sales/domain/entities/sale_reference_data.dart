class SaleClientOption {
  const SaleClientOption({
    required this.id,
    required this.name,
    required this.code,
    required this.city,
  });

  final String id;
  final String name;
  final String code;
  final String city;
}

class SaleProductOption {
  const SaleProductOption({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
  });

  final String id;
  final String name;
  final String sku;
  final double? price;
}

class SalesDraftSeed {
  SalesDraftSeed({
    required List<SaleClientOption> clients,
    required List<SaleProductOption> products,
  }) : clients = List.unmodifiable(clients),
       products = List.unmodifiable(products);

  final List<SaleClientOption> clients;
  final List<SaleProductOption> products;
}
