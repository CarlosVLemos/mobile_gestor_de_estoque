import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/sale_sync.dart';
import '../../domain/repositories/sales_repository.dart';

class SaleIntentsRemoteDataSource implements SaleIntentGateway {
  SaleIntentsRemoteDataSource(this._api, {required this.accessToken});

  final ApiClient _api;
  final String accessToken;
  CancelToken? _pending;

  @override
  Future<SaleIntentOutcome> createIntent(SaleIntentPayload payload) => _send(
    (token) => _api.post<Map<String, dynamic>>(
      '/api/mobile/sale-intents',
      data: _payload(payload),
      options: _options,
      cancelToken: token,
    ),
  );

  @override
  Future<SaleIntentOutcome> confirmIntent({
    required String intentId,
    required String confirmationToken,
  }) => _send(
    (token) => _api.post<Map<String, dynamic>>(
      '/api/mobile/sale-intents/${Uri.encodeComponent(intentId)}/confirm',
      data: {'confirmation_token': confirmationToken},
      options: _options,
      cancelToken: token,
    ),
  );

  Options get _options {
    if (accessToken.isEmpty) throw const UnauthorizedException();
    return Options(headers: {'Authorization': 'Bearer $accessToken'});
  }

  Future<SaleIntentOutcome> _send(
    Future<Response<Map<String, dynamic>>> Function(CancelToken) request,
  ) async {
    final token = CancelToken();
    _pending = token;
    try {
      final response = await request(token);
      return _success(response.statusCode, response.data ?? const {});
    } on ProtocolException catch (error) {
      return _protocolFailure(error);
    } on UnauthorizedException catch (error) {
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.unauthorized,
        code: 'unauthorized',
        message: error.message,
      );
    } on InvalidParamsException catch (error) {
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.permanentFailure,
        code: error.code ?? 'invalid_payload',
        message: error.message,
      );
    } on ForbiddenException catch (error) {
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.blocked,
        code: error.code ?? 'forbidden',
        message: error.message,
      );
    } on NoInternetException catch (error) {
      return _retryable(error.message);
    } on ConnectionTimeoutException catch (error) {
      return _retryable(error.message);
    } on RequestCancelledException {
      return const SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.interrupted,
        code: 'request_cancelled',
      );
    } on RateLimitException catch (error) {
      return _retryable(error.message, code: 'rate_limited');
    } on ServerException catch (error) {
      return _retryable(error.message, code: 'server_error');
    } on ApiException catch (error) {
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.permanentFailure,
        code: 'unsupported_protocol_response',
        message: error.message,
      );
    } finally {
      if (identical(_pending, token)) _pending = null;
    }
  }

  SaleIntentOutcome _success(int? statusCode, Map<String, dynamic> body) {
    final code = _string(body['code']);
    if (statusCode == 201 && code == 'intent_confirmed') {
      final intent = body['intent'];
      final sale = body['sale'];
      final remoteIntentId = intent is Map<String, dynamic>
          ? _remoteId(intent['id'])
          : null;
      final remoteSaleId = sale is Map<String, dynamic>
          ? _remoteId(sale['id'])
          : null;
      if (remoteIntentId == null || remoteSaleId == null) {
        return const SaleIntentOutcome(
          kind: SaleIntentOutcomeKind.permanentFailure,
          code: 'invalid_confirmed_envelope',
        );
      }
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.confirmed,
        code: code,
        remoteIntentId: remoteIntentId,
        remoteSaleId: remoteSaleId,
      );
    }
    if (statusCode == 200 && code == 'idempotent_replay') {
      final intent = body['intent'];
      if (intent is Map<String, dynamic> &&
          _string(intent['state']) == 'confirmed') {
        final intentId = _remoteId(intent['id']);
        if (intentId != null) {
          final sale = body['sale'];
          return SaleIntentOutcome(
            kind: SaleIntentOutcomeKind.confirmed,
            code: code,
            remoteIntentId: intentId,
            remoteSaleId: sale is Map<String, dynamic>
                ? _remoteId(sale['id'])
                : null,
          );
        }
      }
    }
    return const SaleIntentOutcome(
      kind: SaleIntentOutcomeKind.permanentFailure,
      code: 'unexpected_sale_intent_response',
    );
  }

  SaleIntentOutcome _protocolFailure(ProtocolException error) {
    final code = error.code;
    if (error.statusCode == 409 &&
        (code == 'requires_confirmation' || code == 'stock_proposal_changed')) {
      final remoteIntentId = _remoteIdFrom(error.data['intent']);
      final proposalJson = _proposalJson(error.data['proposal']);
      final confirmationToken = _string(error.data['confirmation_token']);
      if (remoteIntentId == null ||
          proposalJson == null ||
          confirmationToken == null) {
        return const SaleIntentOutcome(
          kind: SaleIntentOutcomeKind.permanentFailure,
          code: 'invalid_confirmation_envelope',
        );
      }
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.requiresAcceptance,
        code: code,
        remoteIntentId: remoteIntentId,
        proposalJson: proposalJson,
        confirmationToken: confirmationToken,
        message: error.message,
      );
    }
    if ((error.statusCode == 409 &&
            (code == 'insufficient_stock' || code == 'idempotency_conflict')) ||
        (error.statusCode == 410 && code == 'intent_expired')) {
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.permanentFailure,
        code: code,
        message: error.message,
      );
    }
    if (error.statusCode == 409) {
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.permanentFailure,
        code: code ?? 'unhandled_conflict',
        message: error.message,
      );
    }
    if (error.statusCode == 410) {
      return SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.permanentFailure,
        code: code ?? 'unhandled_gone_response',
        message: error.message,
      );
    }
    return _retryable(error.message, code: code);
  }

  SaleIntentOutcome _retryable(String message, {String? code}) =>
      SaleIntentOutcome(
        kind: SaleIntentOutcomeKind.retryableFailure,
        code: code,
        message: message,
      );

  @override
  void cancelPendingRequest() => _pending?.cancel('sync stopped');
}

Map<String, dynamic> _payload(SaleIntentPayload payload) => {
  'payload_version': SaleIntentPayload.version,
  'client_request_id': payload.clientRequestId,
  'client_id': payload.clientId,
  'status': 'paid',
  'sold_at': payload.soldAt,
  'timezone': payload.timezone,
  'items': [
    for (final item in payload.items)
      {'product_id': item.productId, 'quantity': item.quantity},
  ],
};

String? _string(Object? value) =>
    value is String && value.isNotEmpty ? value : null;

String? _remoteId(Object? value) => switch (value) {
  final int id => id.toString(),
  final String id when id.isNotEmpty => id,
  _ => null,
};

String? _remoteIdFrom(Object? value) =>
    value is Map ? _remoteId(value['id']) : null;

String? _proposalJson(Object? value) =>
    value is Map || value is List ? jsonEncode(value) : null;
