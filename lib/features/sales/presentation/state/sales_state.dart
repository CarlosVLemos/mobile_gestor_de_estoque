import '../../domain/entities/sale_reference_data.dart';

enum SaleSubmissionStatus { idle, registering, uncertain }

class SalesState {
  SalesState({
    required List<SaleClientOption> clients,
    required List<SaleProductOption> products,
    required Map<String, SaleCartItem> cartItems,
    this.selectedClient,
    this.referenceFailure,
    this.submissionStatus = SaleSubmissionStatus.idle,
  }) : clients = List.unmodifiable(clients),
       products = List.unmodifiable(products),
       cartItems = Map.unmodifiable(cartItems);

  final List<SaleClientOption> clients;
  final List<SaleProductOption> products;
  final Map<String, SaleCartItem> cartItems;
  final SaleClientOption? selectedClient;
  final String? referenceFailure;
  final SaleSubmissionStatus submissionStatus;

  bool get isSubmissionBlocked => submissionStatus != SaleSubmissionStatus.idle;

  bool get canRegister =>
      !isSubmissionBlocked && selectedClient != null && cartItems.isNotEmpty;

  bool get hasPendingPrice =>
      cartItems.values.any((item) => item.unitPrice == null);

  SalesState copyWith({
    List<SaleClientOption>? clients,
    List<SaleProductOption>? products,
    Map<String, SaleCartItem>? cartItems,
    SaleClientOption? selectedClient,
    bool clearSelectedClient = false,
    String? referenceFailure,
    bool clearReferenceFailure = false,
    SaleSubmissionStatus? submissionStatus,
  }) {
    return SalesState(
      clients: clients ?? this.clients,
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      selectedClient: clearSelectedClient
          ? null
          : (selectedClient ?? this.selectedClient),
      referenceFailure: clearReferenceFailure
          ? null
          : (referenceFailure ?? this.referenceFailure),
      submissionStatus: submissionStatus ?? this.submissionStatus,
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
