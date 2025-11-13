import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/departamento_model.dart';

class DepartamentoService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/departamentos';

  // GET all departments
  Future<List<Departamento>> listarDepartamentos() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Departamento.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  // GET department by ID
  Future<Departamento> obtenerDepartamento(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return Departamento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load department');
    }
  }

  // POST a new department
  Future<Departamento> crearDepartamento(Departamento departamento) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(departamento.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Departamento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create department');
    }
  }

  // PUT (update) an existing department
  Future<Departamento> actualizarDepartamento(int id, Departamento departamento) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(departamento.toJson()),
    );

    if (response.statusCode == 200) {
      return Departamento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update department');
    }
  }

  // DELETE a department
  Future<void> eliminarDepartamento(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete department');
    }
  }
}
