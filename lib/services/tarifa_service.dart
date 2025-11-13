import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/tarifa_model.dart';

class TarifaService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/tarifas';

  Future<List<Tarifa>> listarTarifas() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Tarifa.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tarifas');
    }
  }

  Future<Tarifa> obtenerTarifa(String temporada) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$temporada'));

    if (response.statusCode == 200) {
      return Tarifa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tarifa');
    }
  }

  Future<Tarifa> crearTarifa(Tarifa tarifa) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarifa.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Tarifa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create tarifa');
    }
  }

  Future<Tarifa> actualizarTarifa(String temporada, Tarifa tarifa) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$temporada'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarifa.toJson()),
    );

    if (response.statusCode == 200) {
      return Tarifa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update tarifa');
    }
  }

  Future<void> eliminarTarifa(String temporada) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$temporada'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete tarifa');
    }
  }
}
