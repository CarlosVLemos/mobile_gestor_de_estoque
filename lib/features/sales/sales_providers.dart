import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/composition/local_context_composition.dart';
import '../../core/config/app_mode.dart';
import '../../core/config/app_timezone.dart';
import 'application/use_cases/load_sales_draft_seed_use_case.dart';
import 'application/use_cases/register_sale_use_case.dart';
import 'data/repositories/drift_sales_draft_repository.dart';
import 'data/repositories/drift_sales_repository.dart';
import 'domain/entities/sale_reference_data.dart';
import 'domain/entities/sale_sync.dart';
import 'domain/repositories/sales_draft_repository.dart';

final salesDraftRepositoryProvider = Provider<SalesDraftRepository>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  final access = ref.watch(operationalReadAccessProvider);
  if (database == null || access == null) {
    throw StateError('Referências persistentes de vendas indisponíveis.');
  }
  return DriftSalesDraftRepository(
    database,
    canViewFinancial: access.canViewFinancialMetrics,
  );
});

final salesDraftSeedProvider = StreamProvider<SalesDraftSeed>((ref) {
  return ref.watch(loadSalesDraftSeedUseCaseProvider).watch();
});

final loadSalesDraftSeedUseCaseProvider = Provider<LoadSalesDraftSeedUseCase>((
  ref,
) {
  return LoadSalesDraftSeedUseCase(ref.watch(salesDraftRepositoryProvider));
});

typedef SalesIdGenerator = String Function();
typedef SalesClock = DateTime Function();

final salesIdGeneratorProvider = Provider<SalesIdGenerator>((ref) {
  return _generateUuid;
});

final salesClockProvider = Provider<SalesClock>((ref) {
  return DateTime.now;
});

final driftSalesRepositoryProvider = Provider<DriftSalesRepository?>((ref) {
  final database = ref.watch(operationalDatabaseProvider);
  return database == null ? null : DriftSalesRepository(database);
});

final registerSaleUseCaseProvider = Provider<RegisterSaleUseCase?>((ref) {
  final repository = ref.watch(driftSalesRepositoryProvider);
  if (repository == null) return null;
  return RegisterSaleUseCase(
    repository: repository,
    idGenerator: ref.watch(salesIdGeneratorProvider),
    clock: ref.watch(salesClockProvider),
  );
});

final persistedSalesProvider = StreamProvider<List<PersistedSaleSummary>>((
  ref,
) {
  final repository = ref.watch(driftSalesRepositoryProvider);
  if (repository == null) {
    throw StateError('Histórico persistente de vendas indisponível.');
  }
  return repository.watchSalesSummary();
});

final salesTimeZoneProvider = Provider<String?>((ref) {
  if (ref.watch(appModeProvider).isDemo) return 'America/Sao_Paulo';
  return ref.watch(appTimeZoneResolverProvider)();
});

String _generateUuid() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  final buffer = StringBuffer();
  for (final byte in bytes) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
  }

  final hex = buffer.toString();
  return '${hex.substring(0, 8)}-'
      '${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-'
      '${hex.substring(20)}';
}
