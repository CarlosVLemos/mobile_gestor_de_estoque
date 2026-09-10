import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/settings/data/repositories/current_operational_context_repository.dart';
import 'package:gestor_de_estoque/features/settings/domain/entities/operational_context.dart';
import 'package:gestor_de_estoque/features/settings/domain/repositories/operational_context_repository.dart';

void main() {
  test('returns the authenticated operational context unchanged', () async {
    final context = OperationalContext(
      userName: 'Maria',
      userEmail: 'maria@example.test',
      tenantName: 'Arara',
      tenantSlug: 'arara',
      features: {'catalog', 'sales'},
      permissions: {'products_view': true, 'sales_create': false},
    );

    final result = await CurrentOperationalContextRepository(context).load();

    expect(result.status, OperationalContextLoadStatus.ready);
    expect(result.context, same(context));
  });

  test('fails closed when no authenticated context exists', () async {
    final result = await const CurrentOperationalContextRepository(null).load();

    expect(result.status, OperationalContextLoadStatus.failure);
    expect(result.context, isNull);
    expect(result.message, contains('indisponível'));
  });
}
