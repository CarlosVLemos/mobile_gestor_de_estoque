import '../../core/database/app_database.dart';
import '../../core/network/api_client.dart';
import 'application/outbox_processor.dart';
import 'data/remote/sale_intents_remote_data_source.dart';
import 'data/repositories/drift_sales_repository.dart';

OutboxProcessor buildSalesOutboxProcessor({
  required AppDatabase database,
  required ApiClient api,
  required String accessToken,
}) {
  final repository = DriftSalesRepository(database);
  return OutboxProcessor(
    store: repository,
    gateway: SaleIntentsRemoteDataSource(api, accessToken: accessToken),
  );
}
