import '../errors/api_exception.dart';
import 'sync_exception.dart';

SyncException syncExceptionFrom(Object error) => switch (error) {
  final SyncException failure => failure,
  NoInternetException() || ConnectionTimeoutException() => const SyncException(SyncFailureKind.offline),
  UnauthorizedException() => const SyncException(SyncFailureKind.unauthorized),
  ForbiddenException() => const SyncException(SyncFailureKind.forbidden),
  RequestCancelledException() => const SyncException(SyncFailureKind.stopping),
  ApiException() => const SyncException(SyncFailureKind.remote),
  FormatException() => const SyncException(SyncFailureKind.invalidData),
  _ => const SyncException(SyncFailureKind.local),
};
