import '../../../../core/network/api_client.dart';
import '../../../../core/network/sync_request.dart';

class RemoteProduct {
  RemoteProduct(Map<String, dynamic> data)
    : id = _id(data['id']),
      name = _text(data['name']),
      sku = _text(data['sku']),
      brand = _text(data['brand']),
      price = _price(data['price']),
      stockQuantity = _integer(data['stock_quantity']),
      stockStatus = _status(data['stock_status']),
      isAvailableForSale = _boolean(data['is_available_for_sale']),
      imageUrl = _nullableText(data['image_url']),
      updatedAt = DateTime.parse(_text(data['updated_at'])).toUtc(),
      categoryId = data['category'] == null
          ? null
          : _id(_object(data['category'])['id']),
      categoryName = data['category'] == null
          ? null
          : _text(_object(data['category'])['name']);

  final String id;
  final String name;
  final String sku;
  final String brand;
  final double? price;
  final int stockQuantity;
  final String stockStatus;
  final bool isAvailableForSale;
  final String? imageUrl;
  final DateTime updatedAt;
  final String? categoryId;
  final String? categoryName;
}

class RemoteProductPage {
  RemoteProductPage({required this.products, required this.hasMore});

  final List<RemoteProduct> products;
  final bool hasMore;
}

class ProductRemoteDataSource {
  ProductRemoteDataSource(this.api);

  final ApiClient api;

  Future<RemoteProductPage> fetch({
    required int page,
    DateTime? updatedSince,
  }) => syncRequest(() async {
    final response = await api.get<Map<String, dynamic>>(
      '/api/mobile/products',
      queryParameters: {
        'per_page': 50,
        'page': page,
        'sort': 'created_at',
        'direction': 'asc',
        if (updatedSince != null) 'updated_since': updatedSince.toUtc().toIso8601String(),
      },
    );
    final body = _object(response.data);
    final meta = _object(body['meta']);
    final data = body['data'];
    final currentPage = _integer(meta['current_page']);
    final lastPage = _integer(meta['last_page']);
    final hasMore = _boolean(meta['has_more_pages']);
    if (data is! List ||
        data.length > 50 ||
        currentPage != page ||
        lastPage < page ||
        hasMore != (currentPage < lastPage) ||
        (hasMore && data.isEmpty)) {
      throw const FormatException('Paginação de produtos inválida.');
    }
    return RemoteProductPage(
      products: List.unmodifiable(data.map((item) => RemoteProduct(_object(item)))),
      hasMore: hasMore,
    );
  });
}

Map<String, dynamic> _object(Object? value) {
  if (value is Map<String, dynamic>) return value;
  throw const FormatException('Objeto esperado.');
}

String _text(Object? value) {
  if (value is String) return value;
  throw const FormatException('Texto esperado.');
}

String? _nullableText(Object? value) => value == null ? null : _text(value);

String _id(Object? value) {
  if (value is int) return value.toString();
  if (value is String && value.isNotEmpty) return value;
  throw const FormatException('Identificador esperado.');
}

int _integer(Object? value) {
  if (value is int) return value;
  throw const FormatException('Inteiro esperado.');
}

bool _boolean(Object? value) {
  if (value is bool) return value;
  throw const FormatException('Booleano esperado.');
}

double? _price(Object? value) {
  if (value == null) return null;
  if (value is num && value.isFinite) return value.toDouble();
  throw const FormatException('Preço inválido.');
}

String _status(Object? value) {
  if (value == 'available' || value == 'low' || value == 'out') return value as String;
  throw const FormatException('Estado de estoque inválido.');
}
