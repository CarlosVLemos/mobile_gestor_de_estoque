import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sales_providers.dart';
import '../../domain/entities/pending_sale.dart';
import '../../domain/entities/sale_reference_data.dart';
import '../state/sales_state.dart';
import 'pending_sales_controller.dart';

final salesControllerProvider = NotifierProvider<SalesController, SalesState>(
  SalesController.new,
);

class SalesController extends Notifier<SalesState> {
  @override
  SalesState build() {
    final seed = ref.watch(loadSalesDraftSeedUseCaseProvider).call();

    return SalesState(
      clients: seed.clients,
      products: seed.products,
      cartItems: const {},
    );
  }

  void selectClient(SaleClientOption client) {
    state = state.copyWith(selectedClient: client);
  }

  void addProduct(SaleProductOption product) {
    final current = state.cartItems[product.id];
    final nextItems = Map<String, SaleCartItem>.from(state.cartItems);

    nextItems[product.id] = current == null
        ? SaleCartItem(
            productId: product.id,
            name: product.name,
            sku: product.sku,
            quantity: 1,
            unitPrice: product.price,
          )
        : current.copyWith(quantity: current.quantity + 1);

    state = state.copyWith(cartItems: nextItems);
  }

  void incrementQuantity(String productId) {
    final current = state.cartItems[productId];
    if (current == null) {
      return;
    }

    state = state.copyWith(
      cartItems: {
        ...state.cartItems,
        productId: current.copyWith(quantity: current.quantity + 1),
      },
    );
  }

  void decrementQuantity(String productId) {
    final current = state.cartItems[productId];
    if (current == null || current.quantity <= 1) {
      return;
    }

    state = state.copyWith(
      cartItems: {
        ...state.cartItems,
        productId: current.copyWith(quantity: current.quantity - 1),
      },
    );
  }

  void removeItem(String productId) {
    final nextItems = Map<String, SaleCartItem>.from(state.cartItems)
      ..remove(productId);
    state = state.copyWith(cartItems: nextItems);
  }

  PendingSale registerSale() {
    final client = state.selectedClient!;
    final sale = PendingSale(
      clientRequestId: _generateUuid(),
      client: client,
      items: [
        for (final item in state.cartItems.values)
          PendingSaleItem(
            productId: item.productId,
            productName: item.name,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
      ],
      createdAtLabel: _buildCreatedAtLabel(),
    );

    ref.read(pendingSalesProvider.notifier).enqueue(sale);
    state = state.copyWith(cartItems: const {}, clearSelectedClient: true);
    return sale;
  }

  String _buildCreatedAtLabel() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _generateUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length; i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    final hex = buffer.toString();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
