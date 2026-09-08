import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard_providers.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/sync/sync_state.dart';
import '../../../../core/sync/sync_exception.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../state/dashboard_state.dart';

final dashboardControllerProvider =
    NotifierProvider.autoDispose<DashboardController, DashboardState>(
      DashboardController.new,
    );

class DashboardController extends Notifier<DashboardState> {
  var _requestSequence = 0;
  ProviderSubscription<AsyncValue<DashboardLoadResult>>? _subscription;
  Completer<void>? _pending;
  DashboardLoadResult? _latest;
  SyncState _sync = const SyncState();
  bool _denied = false;

  @override
  DashboardState build() {
    ref.onDispose(_stop);
    ref.listen(syncStateProvider, (_, next) {
      final value = next.asData?.value;
      if (value == null) return;
      _sync = value;
      if (value.accessDenied || value.failureKind == SyncFailureKind.unauthorized ||
          value.failureKind == SyncFailureKind.forbidden) {
        _denied = true;
      } else if (value.completedCollections.contains('dashboard')) {
        _denied = false;
      }
      if (_latest != null) _applyResult(_latest!);
    }, fireImmediately: true);
    Future<void>.microtask(() async {
      if (ref.mounted) await load();
    });
    return const DashboardState.initial();
  }

  void _stop() {
    _requestSequence++;
    _subscription?.close();
    _subscription = null;
    final pending = _pending;
    if (pending != null && !pending.isCompleted) pending.complete();
  }

  Future<void> load() {
    _stop();
    final requestId = _requestSequence;
    final pending = _pending = Completer<void>();
    state = state.overview == null
        ? const DashboardState.loading()
        : DashboardState.refreshing(state.overview!);
    ref.invalidate(dashboardOverviewStreamProvider);
    _subscription = ref.listen(dashboardOverviewStreamProvider, (_, next) {
      if (!ref.mounted || requestId != _requestSequence) return;
      final result = next.asData?.value;
      if (result != null) {
        _latest = result;
        _applyResult(result);
      } else if (next.hasError) {
        state = DashboardState.failure(
          state.overview == null
              ? 'Não foi possível carregar o painel neste momento.'
              : 'Não foi possível atualizar o painel neste momento.',
          previous: state.overview,
        );
      } else {
        return;
      }
      if (!pending.isCompleted) pending.complete();
    }, fireImmediately: true);
    return pending.future;
  }

  Future<void> refresh() async {
    final current = state.overview;
    state = current == null
        ? const DashboardState.loading()
        : DashboardState.refreshing(current);
    await ref.read(synchronizeUseCaseProvider).call();
    if (ref.mounted) await load();
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
    if (_denied) {
      state = const DashboardState.restricted('O acesso foi negado. Valide sua sessão e permissões.');
      return;
    }
    final failed = _sync.status == SyncStatus.failed;
    state = DashboardState(
      status: failed && state.overview == null && state.status != ViewStatus.restricted
          ? ViewStatus.failure : state.status,
      overview: state.overview,
      message: state.message,
      syncing: _sync.status == SyncStatus.syncing,
      syncMessage: !failed ? null : _sync.failureKind == SyncFailureKind.offline
          ? 'Sem conexão. Exibindo os dados disponíveis no dispositivo.'
          : 'A sincronização falhou. Os dados locais foram mantidos.',
    );
  }
}
