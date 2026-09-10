import '../../domain/entities/operational_context.dart';
import '../../domain/repositories/operational_context_repository.dart';

class CurrentOperationalContextRepository
    implements OperationalContextRepository {
  const CurrentOperationalContextRepository(this.context);

  final OperationalContext? context;

  @override
  Future<OperationalContextLoadResult> load() async {
    final current = context;
    if (current == null) {
      return const OperationalContextLoadResult.failure(
        'Contexto autenticado indisponível.',
      );
    }
    return OperationalContextLoadResult.ready(current);
  }
}
