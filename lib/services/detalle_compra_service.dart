import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_route_movil/models/detalle_compra_model.dart';

class DetalleCompraService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final String _endpoint = '/detalles-compra';

  Future<List<DetalleCompra>> listarDetallesCompra() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DetalleCompra.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Detalles de Compra');
    }
  }

  Future<DetalleCompra> obtenerDetalleCompra(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return DetalleCompra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Detalle de Compra');
    }
  }

  Future<DetalleCompra> crearDetalleCompra(DetalleCompra detalle) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(detalle.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DetalleCompra.fromJson(json.decode(response.body));
    } else {
      // Dejamos este bloque de depuración por si surgen errores futuros.
      if (kDebugMode) {
        print('Error al crear DetalleCompra. StatusCode: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      throw Exception('Failed to create Detalle de Compra');
    }
  }

  Future<DetalleCompra> actualizarDetalleCompra(int id, DetalleCompra detalle) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(detalle.toJson()),
    );

    if (response.statusCode == 200) {
      return DetalleCompra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Detalle de Compra');
    }
  }

  Future<void> eliminarDetalleCompra(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete Detalle de Compra');
    }
  }
}
