import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final _storage = const FlutterSecureStorage();
  final _tokenKey = 'jwt_token';

  // Guardar el token de forma segura
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Leer el token guardado
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Borrar el token (para cerrar sesión)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
