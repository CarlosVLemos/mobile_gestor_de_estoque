import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/context_sync_scope.dart';
import 'package:gestor_de_estoque/app/local_context_lifecycle.dart';
import 'package:gestor_de_estoque/core/database/local_context.dart';
import 'package:gestor_de_estoque/core/sync/sync_engine.dart';
import 'package:gestor_de_estoque/core/sync/sync_lease.dart';
import 'package:gestor_de_estoque/core/sync/sync_lock.dart';
import 'package:gestor_de_estoque/core/sync/sync_providers.dart';
import 'package:gestor_de_estoque/features/auth/domain/entities/user_session.dart';
import 'package:gestor_de_estoque/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gestor_de_estoque/features/auth/presentation/state/auth_state.dart';
import 'package:gestor_de_estoque/features/settings/domain/entities/operational_context.dart';
import 'package:gestor_de_estoque/features/settings/settings_providers.dart';

void main() {
  testWidgets('exposes the contextual engine and authenticated profile', (
    tester,
  ) async {
    final engine = SyncEngine(
      context: const LocalContext(userId: 'user-1', tenantId: 'tenant-1'),
      collections: const [],
      lock: SyncLock(),
      leaseStore: _UnusedLeaseStore(),
    );
    SyncEngine? observedEngine;
    OperationalContext? observedContext;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contextSyncEngineProvider.overrideWithValue(engine),
          authControllerProvider.overrideWith(_AuthenticatedController.new),
        ],
        child: MaterialApp(
          home: ContextSyncScope(
            child: Consumer(
              builder: (context, ref, child) {
                observedEngine = ref.watch(syncEngineProvider);
                observedContext = ref.watch(currentOperationalContextProvider);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    expect(observedEngine, same(engine));
    expect(observedContext?.userName, 'Maria');
    expect(observedContext?.tenantSlug, 'arara');
    expect(observedContext?.features, {'catalog', 'sales'});
    expect(observedContext?.permissions['sales_create'], isTrue);
  });
}

class _AuthenticatedController extends AuthController {
  @override
  AuthState build() => const AuthState(
    status: AuthStatus.authenticated,
    session: UserSession(
      userId: 'user-1',
      userName: 'Maria',
      email: 'maria@example.test',
      tenantId: 'tenant-1',
      tenantName: 'Arara',
      tenantSlug: 'arara',
      features: {'catalog', 'sales'},
      permissions: {'products_view': true, 'sales_create': true},
      revision: 'profile-1',
      mustChangePassword: false,
    ),
  );
}

class _UnusedLeaseStore implements SyncLeaseStore {
  @override
  Future<SyncLease?> tryAcquire() async => null;
}
