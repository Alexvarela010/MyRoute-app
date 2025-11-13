import 'package:my_route_movil/models/ruta_turistica_model.dart';

class Tarifa {
  final String temporada;
  final RutaTuristica ruta;
  final bool estado;
  final int costo;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Tarifa({
    required this.temporada,
    required this.ruta,
    required this.estado,
    required this.costo,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Tarifa.fromJson(Map<String, dynamic> json) {
    return Tarifa(
      temporada: json['temporada'],
      ruta: RutaTuristica.fromJson(json['ruta']),
      estado: json['estado'],
      costo: json['costo'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temporada': temporada,
      'ruta': ruta.toJson(),
      'estado': estado,
      'costo': costo,
      'fecha_inicio': fechaInicio.toIso8601String().split('T').first,
      'fecha_fin': fechaFin.toIso8601String().split('T').first,
    };
  }
}
