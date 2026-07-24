import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckAuthUseCase {
  final FlutterSecureStorage _storage;

  CheckAuthUseCase(this._storage);

  Future<bool> execute() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return false;

    return _isTokenValid(token);
  }

  bool _isTokenValid(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final data = jsonDecode(decoded) as Map<String, dynamic>;

      final exp = data['exp'] as int?;
      if (exp == null) return true;

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isBefore(expiresAt);
    } catch (e) {
      return false;
    }
  }
}