import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  SecureTokenStorage(this._storage);
  static const _tokenKey = 'sanctum_access_token';
  final FlutterSecureStorage _storage;
  Future<String?> read() => _storage.read(key: _tokenKey);
  Future<void> write(String token) =>
      _storage.write(key: _tokenKey, value: token);
  Future<void> clear() => _storage.delete(key: _tokenKey);
}
