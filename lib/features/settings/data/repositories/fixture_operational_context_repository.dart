import '../../domain/repositories/operational_context_repository.dart';
import '../local/operational_context_fixture.dart';

class FixtureOperationalContextRepository
    implements OperationalContextRepository {
  const FixtureOperationalContextRepository();

  @override
  Future<OperationalContextLoadResult> load() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return OperationalContextLoadResult.ready(buildOperationalContextFixture());
  }
}
