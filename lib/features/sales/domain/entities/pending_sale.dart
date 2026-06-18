import 'sale_reference_data.dart';

class PendingSale {
  const PendingSale({
    required this.clientRequestId,
    required this.client,
    required this.items,
    required this.createdAtLabel,
  });

  final String clientRequestId;
  final SaleClientOption client;
  final List<PendingSaleItem> items;
  final String createdAtLabel;
}

class PendingSaleItem {
  const PendingSaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String productName;
  final int quantity;
  final double? unitPrice;
}
