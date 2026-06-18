import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard_providers.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../state/dashboard_state.dart';

final dashboardControllerProvider =
    NotifierProvider<DashboardController, DashboardState>(
      DashboardController.new,
    );

class DashboardController extends Notifier<DashboardState> {
  var _initialized = false;
  var _requestSequence = 0;

  @override
  DashboardState build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(load);
    }
    return const DashboardState.initial();
  }

  Future<void> load() async {
    final requestId = ++_requestSequence;
    state = DashboardState.loading(previous: state.overview);
    try {
      final result = await ref.read(loadDashboardUseCaseProvider).call();
      if (requestId != _requestSequence) {
        return;
      }
      _applyResult(result);
    } on Object {
      if (requestId != _requestSequence) {
        return;
      }
      state = DashboardState.failure(
        'Não foi possível carregar o painel neste momento.',
        previous: state.overview,
      );
    }
  }

  Future<void> refresh() async {
    final requestId = ++_requestSequence;
    final current = state.overview;
    state = current == null
        ? const DashboardState.loading()
        : DashboardState.refreshing(current);
    try {
      final result = await ref.read(loadDashboardUseCaseProvider).call();
      if (requestId != _requestSequence) {
        return;
      }
      _applyResult(result);
    } on Object {
      if (requestId != _requestSequence) {
        return;
      }
      state = DashboardState.failure(
        'Não foi possível atualizar o painel neste momento.',
        previous: current,
      );
    }
  }

  void _applyResult(DashboardLoadResult result) {
    state = switch (result.status) {
      DashboardLoadStatus.ready => DashboardState.ready(result.overview!),
      DashboardLoadStatus.empty => DashboardState.empty(result.message!),
      DashboardLoadStatus.restricted => DashboardState.restricted(
        result.message!,
      ),
      DashboardLoadStatus.offline => DashboardState.offline(
        result.message!,
        previous: result.overview ?? state.overview,
      ),
      DashboardLoadStatus.failure => DashboardState.failure(
        result.message!,
        previous: result.overview ?? state.overview,
      ),
    };
  }
}
