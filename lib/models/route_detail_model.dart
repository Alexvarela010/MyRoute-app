import 'package:my_route_movil/models/punto_visita_model.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';

// Modelo de vista para la pantalla de detalle de ruta
class RouteDetail {
  final RutaTuristica ruta;
  final List<PuntoVisita> puntosDeVisita;

  RouteDetail({
    required this.ruta,
    required this.puntosDeVisita,
  });
}
