import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/use_cases/load_dashboard_use_case.dart';
import 'data/repositories/fixture_dashboard_repository.dart';
import 'domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return const FixtureDashboardRepository();
});

final loadDashboardUseCaseProvider = Provider<LoadDashboardUseCase>((ref) {
  return LoadDashboardUseCase(ref.watch(dashboardRepositoryProvider));
});
