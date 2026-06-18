import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/dashboard/dashboard_providers.dart';
import 'package:gestor_de_estoque/features/dashboard/data/local/dashboard_fixture.dart';
import 'package:gestor_de_estoque/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gestor_de_estoque/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gestor_de_estoque/shared/ui_states/view_status.dart';

void main() {
  test('carrega conteúdo pronto', () async {
    final repository = _QueuedDashboardRepository();
    final container = _createContainer(repository);

    await _waitForCalls(repository, 1);
    final overview = buildDashboardFixture();
    repository.completeAt(0, DashboardLoadResult.ready(overview));
    await _flush();

    final state = container.read(dashboardControllerProvider);
    expect(state.status, ViewStatus.ready);
    expect(state.overview, same(overview));
    expect(state.message, isNull);
    expect(() => state.overview!.kpis.clear(), throwsUnsupportedError);
  });

  test('refresh mantém dados durante execução e após falha', () async {
    final repository = _QueuedDashboardRepository();
    final container = _createContainer(repository);
    final controller = container.read(dashboardControllerProvider.notifier);
    final overview = buildDashboardFixture();

    await _waitForCalls(repository, 1);
    repository.completeAt(0, DashboardLoadResult.ready(overview));
    await _flush();

    final refresh = controller.refresh();
    await _waitForCalls(repository, 2);
    expect(
      container.read(dashboardControllerProvider).status,
      ViewStatus.refreshing,
    );
    expect(
      container.read(dashboardControllerProvider).overview,
      same(overview),
    );

    repository.completeAt(
      1,
      const DashboardLoadResult.failure('Servidor indisponível'),
    );
    await refresh;

    final state = container.read(dashboardControllerProvider);
    expect(state.status, ViewStatus.failure);
    expect(state.overview, same(overview));
    expect(state.message, 'Servidor indisponível');
  });

  test('offline usa conteúdo devolvido pelo repositório', () async {
    final repository = _QueuedDashboardRepository();
    final container = _createContainer(repository);
    final cached = buildDashboardFixture();

    await _waitForCalls(repository, 1);
    repository.completeAt(
      0,
      DashboardLoadResult.offline('Sem conexão', overview: cached),
    );
    await _flush();

    final state = container.read(dashboardControllerProvider);
    expect(state.status, ViewStatus.offline);
    expect(state.overview, same(cached));
    expect(state.message, 'Sem conexão');
  });

  test('mapeia estados vazio e restrito sem conteúdo residual', () async {
    final repository = _QueuedDashboardRepository();
    final container = _createContainer(repository);
    final controller = container.read(dashboardControllerProvider.notifier);

    await _waitForCalls(repository, 1);
    repository.completeAt(0, const DashboardLoadResult.empty('Sem dados'));
    await _flush();
    expect(
      container.read(dashboardControllerProvider).status,
      ViewStatus.empty,
    );

    final reload = controller.load();
    await _waitForCalls(repository, 2);
    repository.completeAt(
      1,
      const DashboardLoadResult.restricted('Sem permissão'),
    );
    await reload;

    final state = container.read(dashboardControllerProvider);
    expect(state.status, ViewStatus.restricted);
    expect(state.overview, isNull);
    expect(state.message, 'Sem permissão');
  });

  test('resposta de refresh mais nova vence carregamento antigo', () async {
    final repository = _QueuedDashboardRepository();
    final container = _createContainer(repository);
    final controller = container.read(dashboardControllerProvider.notifier);
    final newest = buildDashboardFixture();

    await _waitForCalls(repository, 1);
    final refresh = controller.refresh();
    await _waitForCalls(repository, 2);

    repository.completeAt(1, DashboardLoadResult.ready(newest));
    await refresh;
    repository.completeAt(
      0,
      const DashboardLoadResult.failure('Resposta antiga'),
    );
    await _flush();

    final state = container.read(dashboardControllerProvider);
    expect(state.status, ViewStatus.ready);
    expect(state.overview, same(newest));
    expect(state.message, isNull);
  });

  test('converte exceção inesperada e preserva painel anterior', () async {
    final repository = _QueuedDashboardRepository();
    final container = _createContainer(repository);
    final controller = container.read(dashboardControllerProvider.notifier);
    final overview = buildDashboardFixture();

    await _waitForCalls(repository, 1);
    repository.completeAt(0, DashboardLoadResult.ready(overview));
    await _flush();

    final refresh = controller.refresh();
    await _waitForCalls(repository, 2);
    repository.completeErrorAt(1, StateError('falha bruta'));
    await refresh;

    final state = container.read(dashboardControllerProvider);
    expect(state.status, ViewStatus.failure);
    expect(state.overview, same(overview));
    expect(state.message, contains('atualizar'));
  });
}

ProviderContainer _createContainer(_QueuedDashboardRepository repository) {
  final container = ProviderContainer(
    overrides: [dashboardRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  container.read(dashboardControllerProvider);
  return container;
}

Future<void> _waitForCalls(
  _QueuedDashboardRepository repository,
  int count,
) async {
  while (repository.callCount < count) {
    await _flush();
  }
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

class _QueuedDashboardRepository implements DashboardRepository {
  final _completers = <Completer<DashboardLoadResult>>[];

  int get callCount => _completers.length;

  @override
  Future<DashboardLoadResult> load() {
    final completer = Completer<DashboardLoadResult>();
    _completers.add(completer);
    return completer.future;
  }

  void completeAt(int index, DashboardLoadResult result) {
    _completers[index].complete(result);
  }

  void completeErrorAt(int index, Object error) {
    _completers[index].completeError(error);
  }
}
