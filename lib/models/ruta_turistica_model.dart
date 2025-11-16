import 'package:my_route_movil/models/ciudad_model.dart';
import 'package:my_route_movil/models/punto_visita_model.dart';

class RutaTuristica {
  final int idRutaTuristica;
  final String titulo;
  final String descripcion;
  final String imgUrl;
  final DateTime? fechaCreacion; // Hacer nulable
  final int cantDias;
  final bool? estado; // Hacer nulable
  final double extras;
  final Ciudad? ciudad;
  final List<PuntoVisita>? puntosDeVisita;

  RutaTuristica({
    required this.idRutaTuristica,
    required this.titulo,
    required this.descripcion,
    required this.imgUrl,
    this.fechaCreacion,
    required this.cantDias,
    this.estado,
    required this.extras,
    this.ciudad,
    this.puntosDeVisita,
  });

  factory RutaTuristica.fromJson(Map<String, dynamic> json) {
    return RutaTuristica(
      // --- CORRECCIÓN ---
      // Usamos el operador ?? para asignar un valor por defecto si el campo es nulo.
      idRutaTuristica: json['id_rutaturistica'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      imgUrl: json['url'] ?? '',
      fechaCreacion: json['fecha_creacion'] != null ? DateTime.parse(json['fecha_creacion']) : null,
      cantDias: json['cant_dias'] ?? 0,
      estado: json['estado'],
      extras: (json['extras'] ?? 0.0).toDouble(),
      ciudad: json['ciudad'] != null ? Ciudad.fromJson(json['ciudad']) : null,
      puntosDeVisita: json['puntosDeVisita'] != null
          ? (json['puntosDeVisita'] as List).map((i) => PuntoVisita.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_rutaturistica': idRutaTuristica,
      'titulo': titulo,
      'descripcion': descripcion,
      'url': imgUrl,
      'fecha_creacion': fechaCreacion?.toIso8601String().split('T').first,
      'cant_dias': cantDias,
      'estado': estado,
      'extras': extras,
    };
  }
}
