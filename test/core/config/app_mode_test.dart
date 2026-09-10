import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/config/app_mode.dart';

void main() {
  group('AppMode', () {
    test('default to normal mode when fromEnvironment is default', () {
      final mode = AppMode.fromEnvironment();
      expect(mode, equals(AppMode.normal));
      expect(mode.isNormal, isTrue);
      expect(mode.isDemo, isFalse);
    });
  });
}
