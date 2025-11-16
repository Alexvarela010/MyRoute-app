import 'package:my_route_movil/models/cliente_model.dart';
import 'package:my_route_movil/models/user_info_model.dart';

class Compra {
  final int id;
  final UserInfo? usuario; // Hacer nulable
  final Cliente? cliente; // Hacer nulable
  final DateTime? fecha; // Hacer nulable
  final double totalRuta;
  final double totalOtrosCargos;
  final double total;

  Compra({
    required this.id,
    this.usuario,
    this.cliente,
    this.fecha,
    required this.totalRuta,
    required this.totalOtrosCargos,
    required this.total,
  });

  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      // --- CORRECCIÓN ---
      // Usamos el operador ?? para asignar un valor por defecto si el campo es nulo.
      id: json['id'] ?? 0,
      usuario: json['usuario'] != null ? UserInfo.fromJson(json['usuario']) : null,
      cliente: json['cliente'] != null ? Cliente.fromJson(json['cliente']) : null,
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
      totalRuta: (json['total_ruta'] ?? 0.0).toDouble(),
      totalOtrosCargos: (json['total_otros_cargos'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario?.toJson(),
      'cliente': cliente?.toJson(),
      'fecha': fecha?.toIso8601String().split('T').first,
      'total_ruta': totalRuta,
      'total_otros_cargos': totalOtrosCargos,
      'total': total,
    };
  }
}
