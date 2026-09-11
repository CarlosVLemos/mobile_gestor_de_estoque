import '../../domain/entities/sale_sync.dart';
import '../../domain/repositories/sales_repository.dart';

typedef SaleIdGenerator = String Function();
typedef SaleClock = DateTime Function();

class RegisterSaleUseCase {
  const RegisterSaleUseCase({
    required SalesRepository repository,
    required SaleIdGenerator idGenerator,
    required SaleClock clock,
  }) : this._(repository, idGenerator, clock);

  const RegisterSaleUseCase._(
    this._repository,
    this._idGenerator,
    this._clock,
  );

  final SalesRepository _repository;
  final SaleIdGenerator _idGenerator;
  final SaleClock _clock;

  Future<String> call({
    required SaleDraft draft,
    required SaleAccess access,
  }) async {
    if (!access.allowsCreate) {
      throw const SaleRegistrationException(
        'sales_create_forbidden',
        'A sessão atual não permite registrar novas vendas.',
      );
    }
    if (draft.items.isEmpty || draft.items.any((item) => item.quantity <= 0)) {
      throw const SaleRegistrationException(
        'invalid_sale',
        'A venda exige ao menos um item com quantidade válida.',
      );
    }
    final id = _idGenerator();
    final now = _clock();
    return _repository.register(
      localSaleId: id,
      clientRequestId: id,
      draft: draft,
      createdAt: now,
    );
  }
}
