import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/user_info_model.dart';

// Modelo simple para la solicitud de autenticación
class AuthRequest {
  final String email;
  final String password;

  AuthRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class AuthService {
  // Quitamos /api del baseUrl porque estos endpoints no lo usan
  final String _baseUrl = dotenv.env['API_BASE_URL']!.replaceAll('/api', '');

  // POST para registrar un nuevo usuario
  Future<String> register(UserInfo userInfo) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/addNewUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userInfo.toJson()),
    );

    if (response.statusCode == 200) {
      // El backend devuelve un String de éxito
      return response.body;
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  // POST para iniciar sesión y obtener un token
  Future<String> login(String email, String password) async {
    final authRequest = AuthRequest(email: email, password: password);

    final response = await http.post(
      Uri.parse('$_baseUrl/generateToken'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authRequest.toJson()),
    );

    if (response.statusCode == 200) {
      // El backend devuelve el token como un String
      return response.body;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}
