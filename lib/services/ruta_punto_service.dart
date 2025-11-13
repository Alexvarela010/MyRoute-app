import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/ruta_punto_model.dart';

class RutaPuntoService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/ruta-puntos';

  Future<List<RutaPunto>> listarRutaPuntos() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RutaPunto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load RutaPuntos');
    }
  }

  Future<RutaPunto> obtenerRutaPunto(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return RutaPunto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load RutaPunto');
    }
  }

  Future<RutaPunto> crearRutaPunto(RutaPunto rutaPunto) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(rutaPunto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RutaPunto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create RutaPunto');
    }
  }

  Future<RutaPunto> actualizarRutaPunto(int id, RutaPunto rutaPunto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(rutaPunto.toJson()),
    );

    if (response.statusCode == 200) {
      return RutaPunto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update RutaPunto');
    }
  }

  Future<void> eliminarRutaPunto(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete RutaPunto');
    }
  }
}
