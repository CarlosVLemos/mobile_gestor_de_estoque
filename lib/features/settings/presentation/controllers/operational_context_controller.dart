import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings_providers.dart';
import '../../domain/repositories/operational_context_repository.dart';
import '../state/operational_context_state.dart';

final operationalContextControllerProvider =
    NotifierProvider<OperationalContextController, OperationalContextState>(
      OperationalContextController.new,
    );

class OperationalContextController extends Notifier<OperationalContextState> {
  var _initialized = false;
  var _requestSequence = 0;

  @override
  OperationalContextState build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(load);
    }
    return const OperationalContextState.loading();
  }

  Future<void> load() async {
    final requestId = ++_requestSequence;
    state = const OperationalContextState.loading();
    try {
      final result = await ref.read(getOperationalContextUseCaseProvider).call();
      if (requestId != _requestSequence) {
        return;
      }

      state = switch (result.status) {
        OperationalContextLoadStatus.ready => OperationalContextState.ready(
          result.context!,
        ),
        OperationalContextLoadStatus.restricted =>
          OperationalContextState.restricted(result.message!),
        OperationalContextLoadStatus.failure =>
          OperationalContextState.failure(result.message!),
      };
    } on Object {
      if (requestId != _requestSequence) {
        return;
      }
      state = const OperationalContextState.failure(
        'Não foi possível carregar o contexto neste momento.',
      );
    }
  }
}
