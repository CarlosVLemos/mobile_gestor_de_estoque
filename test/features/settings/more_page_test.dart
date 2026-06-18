import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/features/settings/domain/repositories/operational_context_repository.dart';
import 'package:gestor_de_estoque/features/settings/presentation/pages/more_page.dart';
import 'package:gestor_de_estoque/features/settings/settings_providers.dart';

void main() {
  testWidgets('mostra bloqueio quando contexto está restrito', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          operationalContextRepositoryProvider.overrideWithValue(
            const _RestrictedContextRepository(),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const MorePage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Contexto operacional restrito'), findsOneWidget);
    expect(find.text('Tenant suspenso'), findsOneWidget);
  });
}

class _RestrictedContextRepository implements OperationalContextRepository {
  const _RestrictedContextRepository();

  @override
  Future<OperationalContextLoadResult> load() async {
    return const OperationalContextLoadResult.restricted('Tenant suspenso');
  }
}
