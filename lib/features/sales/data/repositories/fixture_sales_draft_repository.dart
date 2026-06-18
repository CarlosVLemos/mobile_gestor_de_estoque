import '../../domain/entities/sale_reference_data.dart';
import '../../domain/repositories/sales_draft_repository.dart';
import '../local/sales_draft_fixture.dart';

class FixtureSalesDraftRepository implements SalesDraftRepository {
  const FixtureSalesDraftRepository();

  @override
  SalesDraftSeed loadDraftSeed() {
    return buildSalesDraftSeedFixture();
  }
}
