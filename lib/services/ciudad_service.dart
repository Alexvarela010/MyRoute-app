import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/ciudad_model.dart';

class CiudadService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/ciudades';

  // GET all cities
  Future<List<Ciudad>> listarCiudades() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ciudad.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  // GET city by ID
  Future<Ciudad> obtenerCiudad(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return Ciudad.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load city');
    }
  }

  // POST a new city
  Future<Ciudad> crearCiudad(Ciudad ciudad) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ciudad.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Ciudad.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create city');
    }
  }

  // PUT (update) an existing city
  Future<Ciudad> actualizarCiudad(int id, Ciudad ciudad) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ciudad.toJson()),
    );

    if (response.statusCode == 200) {
      return Ciudad.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update city');
    }
  }

  // DELETE a city
  Future<void> eliminarCiudad(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete city');
    }
  }
}
