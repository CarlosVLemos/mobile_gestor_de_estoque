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

  @override
  DashboardState build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(load);
    }
    return const DashboardState.initial();
  }

  Future<void> load() async {
    state = DashboardState.loading(previous: state.overview);
    final result = await ref.read(loadDashboardUseCaseProvider).call();
    _applyResult(result);
  }

  Future<void> refresh() async {
    final current = state.overview;
    if (current != null) {
      state = DashboardState.refreshing(current);
    }
    final result = await ref.read(loadDashboardUseCaseProvider).call();
    _applyResult(result);
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
