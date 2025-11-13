import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/compra_model.dart';

class CompraService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/compras';

  Future<List<Compra>> listarCompras() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Compra.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load compras');
    }
  }

  Future<Compra> obtenerCompra(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return Compra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load compra');
    }
  }

  Future<Compra> crearCompra(Compra compra) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(compra.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Compra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create compra');
    }
  }

  Future<Compra> actualizarCompra(int id, Compra compra) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(compra.toJson()),
    );

    if (response.statusCode == 200) {
      return Compra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update compra');
    }
  }

  Future<void> eliminarCompra(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete compra');
    }
  }
}
