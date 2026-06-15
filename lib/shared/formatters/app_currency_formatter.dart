abstract final class AppCurrencyFormatter {
  const AppCurrencyFormatter._();

  static String format(double value) {
    final negative = value < 0;
    final absolute = value.abs();
    final fixed = absolute.toStringAsFixed(2);
    final parts = fixed.split('.');
    final integer = parts.first;
    final cents = parts.last;

    final buffer = StringBuffer();
    for (var index = 0; index < integer.length; index++) {
      final reverseIndex = integer.length - index;
      buffer.write(integer[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    final prefix = negative ? '-R\$ ' : 'R\$ ';
    return '$prefix${buffer.toString().replaceAll('..', '.')},$cents';
  }
}
