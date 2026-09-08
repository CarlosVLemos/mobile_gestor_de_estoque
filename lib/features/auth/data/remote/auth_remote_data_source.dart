import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);
  final ApiClient _client;
  static const _prefix = '/api/mobile';

  Future<Map<String, dynamic>> login(Map<String, dynamic> payload) async =>
      (await _client.post<Map<String, dynamic>>(
        '$_prefix/auth/login',
        data: payload,
      )).data!;
  Future<Map<String, dynamic>> me(String token) async =>
      (await _client.get<Map<String, dynamic>>(
        '$_prefix/me',
        options: _bearer(token),
      )).data!;
  Future<void> logout(String token) async {
    await _client.post<void>('$_prefix/auth/logout', options: _bearer(token));
  }

  Future<void> changePassword(
    String token,
    Map<String, dynamic> payload,
  ) async {
    await _client.put<void>(
      '$_prefix/me/password',
      data: payload,
      options: _bearer(token),
    );
  }

  Options _bearer(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});
}
