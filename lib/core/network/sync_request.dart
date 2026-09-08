import '../errors/api_exception.dart';
import '../sync/sync_exception.dart';

/// Converte transporte em falhas seguras antes de entrar na engine.
Future<T> syncRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on NoInternetException {
    throw const SyncException(SyncFailureKind.offline);
  } on ConnectionTimeoutException {
    throw const SyncException(SyncFailureKind.offline);
  } on UnauthorizedException {
    throw const SyncException(SyncFailureKind.unauthorized);
  } on ForbiddenException {
    throw const SyncException(SyncFailureKind.forbidden);
  } on ApiException {
    throw const SyncException(SyncFailureKind.remote);
  } on FormatException {
    throw const SyncException(SyncFailureKind.invalidData);
  }
}
