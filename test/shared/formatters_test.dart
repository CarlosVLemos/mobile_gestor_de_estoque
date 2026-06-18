import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/shared/formatters/app_currency_formatter.dart';
import 'package:gestor_de_estoque/shared/formatters/app_date_formatter.dart';
import 'package:gestor_de_estoque/shared/formatters/app_stock_formatter.dart';

void main() {
  group('AppCurrencyFormatter', () {
    test('formata zero, milhares, centavos e negativos', () {
      expect(AppCurrencyFormatter.format(0), 'R\$ 0,00');
      expect(AppCurrencyFormatter.format(12.5), 'R\$ 12,50');
      expect(AppCurrencyFormatter.format(1234567.89), 'R\$ 1.234.567,89');
      expect(AppCurrencyFormatter.format(-42.1), '-R\$ 42,10');
    });

    test('arredonda para duas casas decimais', () {
      expect(AppCurrencyFormatter.format(1.005), 'R\$ 1,00');
      expect(AppCurrencyFormatter.format(1.006), 'R\$ 1,01');
    });
  });

  test('AppDateFormatter produz data curta pt-BR', () {
    expect(
      AppDateFormatter.short(DateTime(2026, 6, 18, 9, 7)),
      '18 jun, 09:07',
    );
  });

  test('AppStockFormatter diferencia singular, zero e plural', () {
    expect(AppStockFormatter.units(0), '0 unidades');
    expect(AppStockFormatter.units(1), '1 unidade');
    expect(AppStockFormatter.units(2), '2 unidades');
  });
}
