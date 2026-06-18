import 'dart:math';

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

typedef SalesIdGenerator = String Function();
typedef SalesClock = DateTime Function();

final salesIdGeneratorProvider = Provider<SalesIdGenerator>((ref) {
  return _generateUuid;
});

final salesClockProvider = Provider<SalesClock>((ref) {
  return DateTime.now;
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
