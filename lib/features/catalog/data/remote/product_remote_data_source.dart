import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/sync/sync_error_mapper.dart';

class RemoteProduct {
  RemoteProduct(Map<String, dynamic> value)
      : id = _requiredProductId(value['id']),
        name = _requiredText(value['name']),
        sku = _requiredText(value['sku']),
        brand = _nullableText(value['brand']),
        price = _price(value['price']),
        stockQuantity = _integer(value['stock_quantity']),
        stockStatus = _requiredText(value['stock_status']),
        isAvailableForSale = _bool(value['is_available_for_sale']),
        imageUrl = _nullableText(value['image_url']),
        updatedAt = _date(value['updated_at']),
        category = _category(value['category']);

  final String id, name, sku, stockStatus;
  final String? brand, imageUrl;
  final double? price;
  final int stockQuantity;
  final bool isAvailableForSale;
  final DateTime? updatedAt;
  final RemoteCategory? category;
}

class RemoteCategory {
  const RemoteCategory(this.id, this.name);
  final String id, name;
}

class RemoteTombstone {
  RemoteTombstone(Map<String, dynamic> value)
      : id = _requiredProductId(value['id']),
        deletedAt = _requiredDate(value['deleted_at']);
  final String id;
  final DateTime deletedAt;
}

class RemoteProductPage {
  RemoteProductPage(Map<String, dynamic> value)
      : products = _list(value['data']).map((item) => RemoteProduct(_object(item))).toList(growable: false),
        tombstones = _list(value['tombstones']).map((item) => RemoteTombstone(_object(item))).toList(growable: false),
        hasMore = _bool(_object(value['meta'])['has_more']),
        nextCursor = _nullableText(_object(value['meta'])['next_cursor']),
        targetCheckpoint = _requiredDate(_object(value['meta'])['target_checkpoint']) {
    if (hasMore != (nextCursor != null)) throw const FormatException('Cursor de produtos incompatível com has_more.');
  }
  final List<RemoteProduct> products;
  final List<RemoteTombstone> tombstones;
  final bool hasMore;
  final String? nextCursor;
  final DateTime targetCheckpoint;
}

class ProductRemoteDataSource {
  ProductRemoteDataSource(this._api, {required this.accessToken});
  final ApiClient _api;
  final String accessToken;
  CancelToken? _pending;

  Future<RemoteProductPage> fetch({String? cursor, String? checkpoint}) async {
    final token = CancelToken();
    _pending = token;
    try {
      if (accessToken.isEmpty) {
        throw const UnauthorizedException();
      }
      final response = await _api.get<Map<String, dynamic>>('/api/mobile/products', queryParameters: {
        'per_page': 50,
        'cursor': ?cursor,
        'checkpoint': ?checkpoint,
      }, options: Options(headers: {'Authorization': 'Bearer $accessToken'}), cancelToken: token);
      final body = response.data;
      if (body == null) throw const FormatException('Resposta de produtos vazia.');
      return RemoteProductPage(body);
    } on Object catch (error) {
      throw syncExceptionFrom(error);
    } finally {
      if (identical(_pending, token)) _pending = null;
    }
  }

  void cancelPendingRequest() => _pending?.cancel('sync stopped');
}

Map<String, dynamic> _object(Object? value) => value is Map<String, dynamic> ? value : throw const FormatException('Objeto esperado.');
List<dynamic> _list(Object? value) => value is List ? value : throw const FormatException('Lista esperada.');
String _requiredText(Object? value) => value is String && value.isNotEmpty ? value : throw const FormatException('Texto esperado.');
String _requiredProductId(Object? value) {
  final parsed = switch (value) {
    int id => id,
    String text => int.tryParse(text),
    _ => null,
  };
  if (parsed == null || parsed <= 0) {
    throw const FormatException('ID de produto inválido.');
  }
  return parsed.toString();
}
final _uuidPattern = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
);
String _requiredCategoryId(Object? value) {
  if (value is! String || !_uuidPattern.hasMatch(value)) {
    throw const FormatException('ID de categoria inválido.');
  }
  return value;
}
String? _nullableText(Object? value) => value == null ? null : _requiredText(value);
int _integer(Object? value) => value is int ? value : throw const FormatException('Inteiro esperado.');
bool _bool(Object? value) => value is bool ? value : throw const FormatException('Booleano esperado.');
double? _price(Object? value) => value == null ? null : value is num && value.isFinite ? value.toDouble() : throw const FormatException('Preço inválido.');
DateTime? _date(Object? value) => value == null ? null : _requiredDate(value);
DateTime _requiredDate(Object? value) { final parsed = value is String ? DateTime.tryParse(value) : null; return parsed?.toUtc() ?? (throw const FormatException('Data inválida.')); }
RemoteCategory? _category(Object? value) { if (value == null) return null; final map = _object(value); return RemoteCategory(_requiredCategoryId(map['id']), _requiredText(map['name'])); }
