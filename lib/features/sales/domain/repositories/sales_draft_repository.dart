import '../entities/sale_reference_data.dart';

abstract class SalesDraftRepository {
  SalesDraftSeed loadDraftSeed();
}

abstract interface class ReactiveSalesDraftRepository
    implements SalesDraftRepository {
  Stream<SalesDraftSeed> watchDraftSeed();
}
