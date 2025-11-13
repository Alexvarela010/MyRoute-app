import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/cliente_model.dart';

class ClienteService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/clientes';

  Future<List<Cliente>> listarClientes() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clientes');
    }
  }

  Future<Cliente> obtenerCliente(String cedula) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$cedula'));

    if (response.statusCode == 200) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cliente');
    }
  }

  Future<Cliente> crearCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create cliente');
    }
  }

  Future<Cliente> actualizarCliente(String cedula, Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$cedula'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );

    if (response.statusCode == 200) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update cliente');
    }
  }

  Future<void> eliminarCliente(String cedula) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$cedula'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete cliente');
    }
  }
}
