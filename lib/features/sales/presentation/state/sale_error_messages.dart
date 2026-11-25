import '../../domain/entities/sale_sync.dart';

/// Only whitelisted codes are converted to user-facing messages.
abstract final class SaleErrorMessages {
  static String registration(Object error) {
    if (error is SaleRegistrationException) {
      return switch (error.code) {
        'sales_create_forbidden' =>
          'Seu perfil não pode registrar vendas. Verifique seu acesso.',
        'invalid_sale' || 'duplicate_product' =>
          'Revise os produtos e as quantidades da venda.',
        'iana_timezone_unavailable' || 'invalid_timezone' =>
          'Não foi possível configurar o horário. Entre em contato com o suporte.',
        'invalid_remote_id' =>
          'Atualize os dados de clientes e produtos e tente novamente.',
        _ => _registrationFallback,
      };
    }
    return _registrationFallback;
  }

  static const _registrationFallback =
      'Não foi possível concluir o registro. Verifique o estado da venda antes de tentar novamente.';

  static const acceptance =
      'Não foi possível aceitar o ajuste. Atualize o histórico e revise a venda antes de tentar novamente.';
}
