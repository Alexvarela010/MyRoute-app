import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/resenas_model.dart';

class ResenasService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/resenas';

  Future<List<Resena>> listarResenas() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Resena.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load resenas');
    }
  }

  Future<Resena> obtenerResena(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return Resena.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load resena');
    }
  }

  Future<Resena> crearResena(Resena resena) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(resena.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Resena.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create resena');
    }
  }

  Future<Resena> actualizarResena(int id, Resena resena) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(resena.toJson()),
    );

    if (response.statusCode == 200) {
      return Resena.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update resena');
    }
  }

  Future<void> eliminarResena(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete resena');
    }
  }
}
