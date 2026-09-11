import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/config/app_mode.dart';

void main() {
  test('APP_MODE ausente ou vazio usa normal', () {
    expect(AppMode.parse(null), AppMode.normal);
    expect(AppMode.parse(''), AppMode.normal);
    expect(AppMode.parse('  '), AppMode.normal);
  });

  test('APP_MODE aceita normal e demo explicitamente', () {
    expect(AppMode.parse('normal'), AppMode.normal);
    expect(AppMode.parse('demo'), AppMode.demo);
  });

  test('APP_MODE desconhecido falha fechado', () {
    expect(() => AppMode.parse('staging'), throwsStateError);
  });
}
