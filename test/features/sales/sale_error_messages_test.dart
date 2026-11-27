import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/sales/domain/entities/sale_sync.dart';
import 'package:gestor_de_estoque/features/sales/presentation/state/sale_error_messages.dart';

void main() {
  test('orienta para códigos conhecidos sem mostrar mensagem interna', () {
    const error = SaleRegistrationException('invalid_sale', 'token=segredo');
    final message = SaleErrorMessages.registration(error);
    expect(message, contains('quantidades'));
    expect(message, isNot(contains('segredo')));
  });

  test('falhas desconhecidas não exibem exceção ou dados internos', () {
    final errors = [
      StateError('token=segredo'),
      const SaleRegistrationException('unknown', '{"secret":"segredo"}'),
    ];
    for (final error in errors) {
      final message = SaleErrorMessages.registration(error);
      expect(message, contains('Verifique'));
      expect(message, isNot(contains('segredo')));
      expect(message, isNot(contains('StateError')));
    }
  });

  test('falha de aceite orienta a revisar sem expor dados internos', () {
    expect(SaleErrorMessages.acceptance, contains('revise'));
    expect(SaleErrorMessages.acceptance, isNot(contains('token')));
  });
}
