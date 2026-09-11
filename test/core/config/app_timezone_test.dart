import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/config/app_timezone.dart';

void main() {
  test('timezone normal ausente não inventa abreviação nem offset', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final resolved = container.read(appTimeZoneResolverProvider)();
    expect(resolved, isNull);
  });
}
