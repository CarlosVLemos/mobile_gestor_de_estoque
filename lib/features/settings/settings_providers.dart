import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/use_cases/get_operational_context_use_case.dart';
import 'data/repositories/fixture_operational_context_repository.dart';
import 'domain/repositories/operational_context_repository.dart';

final operationalContextRepositoryProvider =
    Provider<OperationalContextRepository>((ref) {
      return const FixtureOperationalContextRepository();
    });

final getOperationalContextUseCaseProvider =
    Provider<GetOperationalContextUseCase>((ref) {
      return GetOperationalContextUseCase(
        ref.watch(operationalContextRepositoryProvider),
      );
    });
