abstract final class AppDateFormatter {
  const AppDateFormatter._();

  static const _months = <int, String>{
    1: 'jan',
    2: 'fev',
    3: 'mar',
    4: 'abr',
    5: 'mai',
    6: 'jun',
    7: 'jul',
    8: 'ago',
    9: 'set',
    10: 'out',
    11: 'nov',
    12: 'dez',
  };

  static String short(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month =
        _months[value.month] ?? value.month.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day $month, $hour:$minute';
  }
}
