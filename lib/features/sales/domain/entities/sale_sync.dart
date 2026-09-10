enum SaleSyncStatus {
  pending,
  syncing,
  confirmed,
  failedRetryable,
  failedPermanent,
  requiresAcceptance,
  cancelled,
}

enum SaleOutboxOperation { createIntent, confirmIntent }

extension SaleSyncStatusValue on SaleSyncStatus {
  String get databaseValue => switch (this) {
    SaleSyncStatus.failedRetryable => 'failed_retryable',
    SaleSyncStatus.failedPermanent => 'failed_permanent',
    SaleSyncStatus.requiresAcceptance => 'requires_acceptance',
    _ => name,
  };

  static SaleSyncStatus parse(String value) => switch (value) {
    'pending' => SaleSyncStatus.pending,
    'syncing' => SaleSyncStatus.syncing,
    'confirmed' => SaleSyncStatus.confirmed,
    'failed_retryable' => SaleSyncStatus.failedRetryable,
    'failed_permanent' => SaleSyncStatus.failedPermanent,
    'requires_acceptance' => SaleSyncStatus.requiresAcceptance,
    'cancelled' => SaleSyncStatus.cancelled,
    _ => throw FormatException('Estado de venda desconhecido: $value'),
  };
}

class SaleDraft {
  SaleDraft({
    required this.clientId,
    required this.clientName,
    required List<SaleDraftItem> items,
    required this.soldAt,
    required this.timezone,
  }) : items = List.unmodifiable(items);

  final String clientId;
  final String clientName;
  final List<SaleDraftItem> items;
  final DateTime soldAt;
  final String timezone;
}

class SaleDraftItem {
  const SaleDraftItem({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.quantity,
    this.historicalUnitPrice,
  });

  final String productId;
  final String productName;
  final String? productSku;
  final int quantity;
  final double? historicalUnitPrice;
}

class SaleIntentPayload {
  SaleIntentPayload({
    required this.clientRequestId,
    required this.clientId,
    required List<SaleIntentItem> items,
    required this.soldAt,
    required this.timezone,
  }) : items = List.unmodifiable(items);

  static const version = 1;
  final String clientRequestId;
  final int clientId;
  final List<SaleIntentItem> items;
  final String soldAt;
  final String timezone;
}

class SaleIntentItem {
  const SaleIntentItem({required this.productId, required this.quantity});
  final int productId;
  final int quantity;
}

class OutboxSale {
  const OutboxSale({
    required this.id,
    required this.localSaleId,
    required this.clientRequestId,
    required this.payload,
    required this.status,
    required this.attempts,
    required this.operation,
    this.nextAttemptAt,
    this.remoteIntentId,
    this.confirmationToken,
    this.proposalRevision = 0,
  });

  final String id;
  final String localSaleId;
  final String clientRequestId;
  final SaleIntentPayload payload;
  final SaleSyncStatus status;
  final int attempts;
  final SaleOutboxOperation operation;
  final DateTime? nextAttemptAt;
  final String? remoteIntentId;
  final String? confirmationToken;
  final int proposalRevision;
}

enum SaleIntentOutcomeKind {
  confirmed,
  requiresAcceptance,
  retryableFailure,
  permanentFailure,
  blocked,
  interrupted,
  unauthorized,
}

class SaleIntentOutcome {
  const SaleIntentOutcome({
    required this.kind,
    this.code,
    this.remoteIntentId,
    this.remoteSaleId,
    this.proposalJson,
    this.confirmationToken,
    this.message,
  });

  final SaleIntentOutcomeKind kind;
  final String? code;
  final String? remoteIntentId;
  final String? remoteSaleId;
  final String? proposalJson;
  final String? confirmationToken;
  final String? message;
}

class SaleAccess {
  const SaleAccess({
    required this.hasSalesFeature,
    required this.canCreateSales,
  });

  final bool hasSalesFeature;
  final bool canCreateSales;

  bool get allowsCreate => hasSalesFeature && canCreateSales;
}

class SaleRegistrationException implements Exception {
  const SaleRegistrationException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => 'SaleRegistrationException($code): $message';
}

class PersistedSaleSummary {
  const PersistedSaleSummary({
    required this.localSaleId,
    required this.clientRequestId,
    required this.clientId,
    required this.clientName,
    required this.soldAt,
    required this.createdAt,
    required this.status,
    required this.itemCount,
    this.totalAmount,
    this.lastError,
  });

  final String localSaleId;
  final String clientRequestId;
  final String clientId;
  final String clientName;
  final DateTime soldAt;
  final DateTime createdAt;
  final SaleSyncStatus status;
  final int itemCount;
  final double? totalAmount;
  final String? lastError;
}

