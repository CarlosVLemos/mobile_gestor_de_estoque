abstract final class AppStockFormatter {
  const AppStockFormatter._();

  static String units(int quantity) {
    if (quantity == 1) {
      return '1 unidade';
    }
    return '$quantity unidades';
  }
}
