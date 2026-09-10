import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/use_cases/get_operational_context_use_case.dart';
import 'data/repositories/current_operational_context_repository.dart';
import 'domain/entities/operational_context.dart';
import 'domain/repositories/operational_context_repository.dart';

final currentOperationalContextProvider = Provider<OperationalContext?>(
  (ref) => null,
);

final operationalContextRepositoryProvider =
    Provider<OperationalContextRepository>((ref) {
      return CurrentOperationalContextRepository(
        ref.watch(currentOperationalContextProvider),
      );
    });

final getOperationalContextUseCaseProvider =
    Provider<GetOperationalContextUseCase>((ref) {
      return GetOperationalContextUseCase(
        ref.watch(operationalContextRepositoryProvider),
      );
    });
