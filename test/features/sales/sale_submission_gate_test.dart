import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/local_context.dart';
import 'package:gestor_de_estoque/features/sales/presentation/state/sale_submission_gate.dart';

void main() {
  const first = LocalContext(userId: '1', tenantId: '1');
  const second = LocalContext(userId: '1', tenantId: '2');

  test('isola tentativas e mantém a incerta bloqueada', () {
    final gate = SaleSubmissionGate();
    addTearDown(gate.dispose);
    expect(gate.begin(first, 'a'), isTrue);
    expect(gate.begin(first, 'b'), isFalse);
    expect(gate.begin(second, 'c'), isTrue);
    gate.uncertain(first, 'a');
    expect(gate.attempt(first)?.status, SaleSubmissionStatus.uncertain);
    gate.finish(first, 'b');
    expect(gate.attempt(first)?.id, 'a');
    gate.finish(first, 'a');
    expect(gate.attempt(first), isNull);
    expect(gate.attempt(second)?.id, 'c');
  });

  test('conclusão tardia após descarte não notifica listeners', () {
    final gate = SaleSubmissionGate();
    gate.begin(first, 'a');
    gate.dispose();
    expect(() => gate.uncertain(first, 'a'), returnsNormally);
    expect(() => gate.finish(first, 'a'), returnsNormally);
  });
}
