import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/settings/domain/entities/operational_context.dart';
import 'package:gestor_de_estoque/features/settings/domain/repositories/operational_context_repository.dart';
import 'package:gestor_de_estoque/features/settings/presentation/controllers/operational_context_controller.dart';
import 'package:gestor_de_estoque/features/settings/settings_providers.dart';
import 'package:gestor_de_estoque/shared/ui_states/view_status.dart';

void main() {
  test('mapeia contexto pronto', () async {
    final repository = _QueuedOperationalContextRepository();
    final container = _createContainer(repository);

    await _waitForCall(repository);
    repository.complete(OperationalContextLoadResult.ready(_operationalContext));
    await _flush();

    final state = container.read(operationalContextControllerProvider);
    expect(state.status, ViewStatus.ready);
    expect(state.context, same(_operationalContext));
    expect(state.message, isNull);
    expect(
      () => state.context!.permissions['products_view'] = false,
      throwsUnsupportedError,
    );
  });

  test('mapeia restrição sem expor contexto anterior', () async {
    final repository = _QueuedOperationalContextRepository();
    final container = _createContainer(repository);
    final controller = container.read(
      operationalContextControllerProvider.notifier,
    );

    await _waitForCall(repository);
    repository.complete(OperationalContextLoadResult.ready(_operationalContext));
    await _flush();

    final reload = controller.load();
    await _waitForCall(repository, count: 2);
    repository.completeAt(
      1,
      const OperationalContextLoadResult.restricted('Tenant bloqueado'),
    );
    await reload;

    final state = container.read(operationalContextControllerProvider);
    expect(state.status, ViewStatus.restricted);
    expect(state.context, isNull);
    expect(state.message, 'Tenant bloqueado');
  });

  test('mapeia falha e permite nova tentativa', () async {
    final repository = _QueuedOperationalContextRepository();
    final container = _createContainer(repository);
    final controller = container.read(
      operationalContextControllerProvider.notifier,
    );

    await _waitForCall(repository);
    repository.complete(
      const OperationalContextLoadResult.failure('Falha temporária'),
    );
    await _flush();
    expect(
      container.read(operationalContextControllerProvider).status,
      ViewStatus.failure,
    );

    final retry = controller.load();
    await _waitForCall(repository, count: 2);
    expect(
      container.read(operationalContextControllerProvider).status,
      ViewStatus.loading,
    );
    repository.completeAt(
      1,
      OperationalContextLoadResult.ready(_operationalContext),
    );
    await retry;

    expect(
      container.read(operationalContextControllerProvider).status,
      ViewStatus.ready,
    );
  });

  test('retry mais novo vence resposta antiga', () async {
    final repository = _QueuedOperationalContextRepository();
    final container = _createContainer(repository);
    final controller = container.read(
      operationalContextControllerProvider.notifier,
    );

    await _waitForCall(repository);
    final retry = controller.load();
    await _waitForCall(repository, count: 2);

    repository.completeAt(
      1,
      OperationalContextLoadResult.ready(_operationalContext),
    );
    await retry;
    repository.completeAt(
      0,
      const OperationalContextLoadResult.failure('Resposta antiga'),
    );
    await _flush();

    final state = container.read(operationalContextControllerProvider);
    expect(state.status, ViewStatus.ready);
    expect(state.context, same(_operationalContext));
  });

  test('converte exceção inesperada em falha', () async {
    final repository = _QueuedOperationalContextRepository();
    final container = _createContainer(repository);

    await _waitForCall(repository);
    repository.completeErrorAt(0, StateError('falha bruta'));
    await _flush();

    final state = container.read(operationalContextControllerProvider);
    expect(state.status, ViewStatus.failure);
    expect(state.message, contains('contexto'));
  });
}

ProviderContainer _createContainer(
  _QueuedOperationalContextRepository repository,
) {
  final container = ProviderContainer(
    overrides: [
      operationalContextRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  container.read(operationalContextControllerProvider);
  return container;
}

Future<void> _waitForCall(
  _QueuedOperationalContextRepository repository, {
  int count = 1,
}) async {
  while (repository.callCount < count) {
    await _flush();
  }
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

class _QueuedOperationalContextRepository
    implements OperationalContextRepository {
  final _completers = <Completer<OperationalContextLoadResult>>[];

  int get callCount => _completers.length;

  @override
  Future<OperationalContextLoadResult> load() {
    final completer = Completer<OperationalContextLoadResult>();
    _completers.add(completer);
    return completer.future;
  }

  void complete(OperationalContextLoadResult result) {
    completeAt(0, result);
  }

  void completeAt(int index, OperationalContextLoadResult result) {
    _completers[index].complete(result);
  }

  void completeErrorAt(int index, Object error) {
    _completers[index].completeError(error);
  }
}

final _operationalContext = OperationalContext(
  userName: 'Maria',
  userEmail: 'maria@example.test',
  tenantName: 'Arara',
  tenantSlug: 'arara',
  features: {'catalog'},
  permissions: {'products_view': true},
);
