import 'package:my_route_movil/models/cliente_model.dart';
import 'package:my_route_movil/models/user_info_model.dart';

class Compra {
  final int id;
  final UserInfo usuario;
  final Cliente cliente;
  final DateTime fecha;
  final double totalRuta;
  final double totalOtrosCargos;
  final double total;

  Compra({
    required this.id,
    required this.usuario,
    required this.cliente,
    required this.fecha,
    required this.totalRuta,
    required this.totalOtrosCargos,
    required this.total,
  });

  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      id: json['id'],
      usuario: UserInfo.fromJson(json['usuario']),
      cliente: Cliente.fromJson(json['cliente']),
      fecha: DateTime.parse(json['fecha']),
      totalRuta: (json['total_ruta'] as num).toDouble(),
      totalOtrosCargos: (json['total_otros_cargos'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'cliente': cliente.toJson(),
      'fecha': fecha.toIso8601String().split('T').first,
      'total_ruta': totalRuta,
      'total_otros_cargos': totalOtrosCargos,
      'total': total,
    };
  }
}
