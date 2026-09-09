import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/use_cases/load_dashboard_use_case.dart';
import '../../app/local_context_lifecycle.dart';
import 'data/repositories/drift_dashboard_repository.dart';
import 'domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final access = ref.watch(operationalReadAccessProvider);
  if (database == null) throw StateError('Banco local não aberto.');
  final now = DateTime.now();
  final month = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
  return DriftDashboardRepository(
    database,
    'day:$month:1',
    canViewFinancialMetrics: access?.canViewFinancialMetrics == true,
  );
});

final loadDashboardUseCaseProvider = Provider<LoadDashboardUseCase>((ref) {
  return LoadDashboardUseCase(ref.watch(dashboardRepositoryProvider));
});
