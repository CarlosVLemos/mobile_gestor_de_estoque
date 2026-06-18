import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/use_cases/load_sales_draft_seed_use_case.dart';
import 'data/repositories/fixture_sales_draft_repository.dart';
import 'domain/repositories/sales_draft_repository.dart';

final salesDraftRepositoryProvider = Provider<SalesDraftRepository>((ref) {
  return const FixtureSalesDraftRepository();
});

final loadSalesDraftSeedUseCaseProvider = Provider<LoadSalesDraftSeedUseCase>((
  ref,
) {
  return LoadSalesDraftSeedUseCase(ref.watch(salesDraftRepositoryProvider));
});
