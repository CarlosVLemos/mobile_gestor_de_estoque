import '../../domain/entities/sale_reference_data.dart';

class SalesState {
  SalesState({
    required List<SaleClientOption> clients,
    required List<SaleProductOption> products,
    required Map<String, SaleCartItem> cartItems,
    this.selectedClient,
  }) : clients = List.unmodifiable(clients),
       products = List.unmodifiable(products),
       cartItems = Map.unmodifiable(cartItems);

  final List<SaleClientOption> clients;
  final List<SaleProductOption> products;
  final Map<String, SaleCartItem> cartItems;
  final SaleClientOption? selectedClient;

  bool get canRegister => selectedClient != null && cartItems.isNotEmpty;

  bool get hasPendingPrice =>
      cartItems.values.any((item) => item.unitPrice == null);

  SalesState copyWith({
    List<SaleClientOption>? clients,
    List<SaleProductOption>? products,
    Map<String, SaleCartItem>? cartItems,
    SaleClientOption? selectedClient,
    bool clearSelectedClient = false,
  }) {
    return SalesState(
      clients: clients ?? this.clients,
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      selectedClient: clearSelectedClient
          ? null
          : (selectedClient ?? this.selectedClient),
    );
  }
}

class SaleCartItem {
  const SaleCartItem({
    required this.productId,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String name;
  final String sku;
  final int quantity;
  final double? unitPrice;

  double? get subtotal => unitPrice == null ? null : unitPrice! * quantity;

  SaleCartItem copyWith({int? quantity}) {
    return SaleCartItem(
      productId: productId,
      name: name,
      sku: sku,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
    );
  }
}
