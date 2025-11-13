import 'package:my_route_movil/models/punto_visita_model.dart';

class Resena {
  final int id;
  final PuntoVisita puntoVisita;
  final List<String> comentarios;
  final int calificacion;

  Resena({
    required this.id,
    required this.puntoVisita,
    required this.comentarios,
    required this.calificacion,
  });

  factory Resena.fromJson(Map<String, dynamic> json) {
    return Resena(
      id: json['id'],
      puntoVisita: PuntoVisita.fromJson(json['puntoVisita']),
      // Asegurarse de que la lista se parsea correctamente
      comentarios: List<String>.from(json['comentarios']),
      calificacion: json['calificacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'puntoVisita': puntoVisita.toJson(),
      'comentarios': comentarios,
      'calificacion': calificacion,
    };
  }
}
