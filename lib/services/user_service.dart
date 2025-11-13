import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_route_movil/models/user_info_model.dart';
import 'package:my_route_movil/services/token_service.dart';

class UserService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final TokenService _tokenService = TokenService();

  // Obtener los datos del usuario actualmente logueado
  Future<UserInfo> getMe() async {
    // 1. Obtener el token
    final token = await _tokenService.getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    // 2. Decodificar el token para obtener el email
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userEmail = decodedToken['sub']; // 'sub' es el campo estándar para el sujeto (email) en JWT

    if (userEmail == null) {
      throw Exception('Invalid token format');
    }

    // 3. Llamar a la API para obtener la información completa del usuario
    // Este endpoint está en la raíz, no en /api
    final userApiUrl = _baseUrl.replaceAll('/api', '');
    final response = await http.get(Uri.parse('$userApiUrl/usuarios/email/$userEmail'));

    if (response.statusCode == 200) {
      return UserInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
