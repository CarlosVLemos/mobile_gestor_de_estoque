import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/sync/sync_error_mapper.dart';

class RemoteClient {
  RemoteClient(Map<String, dynamic> value)
    : id = _positiveId(value['id']),
      name = _requiredText(value['name']),
      city = _nullableText(value['city']),
      state = _nullableText(value['state']);

  final String id;
  final String name;
  final String? city;
  final String? state;
}

class RemoteClientPage {
  RemoteClientPage(Map<String, dynamic> value)
    : clients = _list(
        value['data'],
      ).map((item) => RemoteClient(_object(item))).toList(growable: false),
      hasMore = _bool(_object(value['meta'])['has_more']),
      nextCursor = _nullableText(_object(value['meta'])['next_cursor']),
      snapshotUpperBoundId = _nonNegativeInt(
        _object(value['meta'])['snapshot_upper_bound_id'],
      ) {
    if (hasMore != (nextCursor != null)) {
      throw const FormatException('Cursor de clientes incompatível.');
    }
    var previousId = 0;
    for (final client in clients) {
      final id = int.parse(client.id);
      if (id <= previousId || id > snapshotUpperBoundId) {
        throw const FormatException('Snapshot de clientes fora de ordem.');
      }
      previousId = id;
    }
  }

  final List<RemoteClient> clients;
  final bool hasMore;
  final String? nextCursor;
  final int snapshotUpperBoundId;
}

class ClientRemoteDataSource {
  ClientRemoteDataSource(this._api, {required this.accessToken});

  final ApiClient _api;
  final String accessToken;
  CancelToken? _pending;

  Future<RemoteClientPage> fetch({String? cursor}) async {
    final token = CancelToken();
    _pending = token;
    try {
      if (accessToken.isEmpty) {
        throw const UnauthorizedException();
      }
      final response = await _api.get<Map<String, dynamic>>(
        '/api/mobile/clients',
        queryParameters: {'per_page': 50, 'cursor': ?cursor},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        cancelToken: token,
      );
      final body = response.data;
      if (body == null) {
        throw const FormatException('Resposta de clientes vazia.');
      }
      return RemoteClientPage(body);
    } on Object catch (error) {
      throw syncExceptionFrom(error);
    } finally {
      if (identical(_pending, token)) {
        _pending = null;
      }
    }
  }

  void cancelPendingRequest() => _pending?.cancel('sync stopped');
}

Map<String, dynamic> _object(Object? value) => value is Map<String, dynamic>
    ? value
    : throw const FormatException('Objeto esperado.');
List<dynamic> _list(Object? value) =>
    value is List ? value : throw const FormatException('Lista esperada.');
String _requiredText(Object? value) =>
    value is String && value.trim().isNotEmpty
    ? value
    : throw const FormatException('Texto esperado.');
String? _nullableText(Object? value) => value == null
    ? null
    : value is String
    ? value
    : throw const FormatException('Texto opcional esperado.');
bool _bool(Object? value) =>
    value is bool ? value : throw const FormatException('Booleano esperado.');
int _nonNegativeInt(Object? value) => value is int && value >= 0
    ? value
    : throw const FormatException('Inteiro não negativo esperado.');
String _positiveId(Object? value) {
  final id = value is int ? value : null;
  if (id == null || id <= 0) {
    throw const FormatException('ID de cliente inválido.');
  }
  return id.toString();
}
