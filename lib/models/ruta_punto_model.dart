import 'package:my_route_movil/models/punto_visita_model.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';

class RutaPunto {
  final int idRutaPunto;
  final PuntoVisita actividad;
  final RutaTuristica ruta;

  RutaPunto({
    required this.idRutaPunto,
    required this.actividad,
    required this.ruta,
  });

  factory RutaPunto.fromJson(Map<String, dynamic> json) {
    return RutaPunto(
      idRutaPunto: json['id_ruta_punto'],
      actividad: PuntoVisita.fromJson(json['actividad']),
      ruta: RutaTuristica.fromJson(json['ruta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ruta_punto': idRutaPunto,
      'actividad': actividad.toJson(),
      'ruta': ruta.toJson(),
    };
  }
}
