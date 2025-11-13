import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/punto_visita_model.dart';

class PuntoVisitaService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/puntos-visita';

  Future<List<PuntoVisita>> listarPuntosVisita() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PuntoVisita.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Puntos de Visita');
    }
  }

  Future<PuntoVisita> obtenerPuntoVisita(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return PuntoVisita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Punto de Visita');
    }
  }

  Future<PuntoVisita> crearPuntoVisita(PuntoVisita puntoVisita) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(puntoVisita.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PuntoVisita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create Punto de Visita');
    }
  }

  Future<PuntoVisita> actualizarPuntoVisita(int id, PuntoVisita puntoVisita) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(puntoVisita.toJson()),
    );

    if (response.statusCode == 200) {
      return PuntoVisita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Punto de Visita');
    }
  }

  Future<void> eliminarPuntoVisita(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete Punto de Visita');
    }
  }
}
