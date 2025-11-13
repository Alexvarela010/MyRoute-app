import 'package:my_route_movil/models/ciudad_model.dart';
import 'package:my_route_movil/models/departamento_model.dart';

class PuntoVisita {
  final int id;
  final String nombreActividad;
  final String descripcion;
  final bool estado;
  final String urlmaps;
  final String imgUrl;
  final double precio;
  final double duracion;
  final Departamento departamento;
  final Ciudad ciudad;

  PuntoVisita({
    required this.id,
    required this.nombreActividad,
    required this.descripcion,
    required this.estado,
    required this.urlmaps,
    required this.imgUrl,
    required this.precio,
    required this.duracion,
    required this.departamento,
    required this.ciudad,
  });

  factory PuntoVisita.fromJson(Map<String, dynamic> json) {
    return PuntoVisita(
      id: json['id'],
      // En Dart, es convención usar camelCase (nombreActividad)
      // Es importante asegurarse que el backend envíe 'nombre_actividad'
      nombreActividad: json['nombre_actividad'], 
      descripcion: json['descripcion'],
      estado: json['estado'],
      urlmaps: json['urlmaps'],
      imgUrl: json['imgUrl'],
      precio: (json['precio'] as num).toDouble(),
      duracion: (json['duracion'] as num).toDouble(),
      departamento: Departamento.fromJson(json['departamento']),
      ciudad: Ciudad.fromJson(json['ciudad']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_actividad': nombreActividad,
      'descripcion': descripcion,
      'estado': estado,
      'urlmaps': urlmaps,
      'imgUrl': imgUrl,
      'precio': precio,
      'duracion': duracion,
      'departamento': departamento.toJson(),
      'ciudad': ciudad.toJson(),
    };
  }
}
