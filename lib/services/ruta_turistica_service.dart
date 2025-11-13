import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/route_detail_model.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';
import 'package:my_route_movil/services/ruta_punto_service.dart';

class RutaTuristicaService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/rutas';

  // Instancia del servicio que necesitamos para obtener los puntos de la ruta
  final RutaPuntoService _rutaPuntoService = RutaPuntoService();

  Future<List<RutaTuristica>> listarRutasTuristicas() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RutaTuristica.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Rutas Turisticas');
    }
  }

  Future<RutaTuristica> obtenerRutaTuristica(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return RutaTuristica.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Ruta Turistica');
    }
  }
  
  // Método para obtener el detalle completo de la ruta
  Future<RouteDetail> getRouteDetail(int id) async {
    try {
      // 1. Obtener la información básica de la ruta
      final ruta = await obtenerRutaTuristica(id);

      // 2. Obtener todas las relaciones Ruta-Punto
      final todosLosRutaPuntos = await _rutaPuntoService.listarRutaPuntos();

      // 3. Filtrar para encontrar los puntos que pertenecen a ESTA ruta
      final puntosDeVisita = todosLosRutaPuntos
          .where((rutaPunto) => rutaPunto.ruta.idRutaTuristica == id)
          .map((rutaPunto) => rutaPunto.actividad) // Extraer solo el PuntoVisita
          .toList();

      // 4. Devolver el modelo de vista combinado
      return RouteDetail(ruta: ruta, puntosDeVisita: puntosDeVisita);
    } catch (e) {
      throw Exception('Failed to get route detail: $e');
    }
  }

  Future<RutaTuristica> crearRutaTuristica(RutaTuristica ruta) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ruta.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RutaTuristica.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create Ruta Turistica');
    }
  }

  Future<RutaTuristica> actualizarRutaTuristica(int id, RutaTuristica ruta) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ruta.toJson()),
    );

    if (response.statusCode == 200) {
      return RutaTuristica.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Ruta Turistica');
    }
  }

  Future<void> eliminarRutaTuristica(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete Ruta Turistica');
    }
  }
}
