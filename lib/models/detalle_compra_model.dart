import 'package:my_route_movil/models/compra_model.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';

class DetalleCompra {
  final int id;
  final RutaTuristica ruta;
  final Compra compra;
  final int valorRuta;
  final int cantidadPersonas;
  final int valorTotal;

  DetalleCompra({
    required this.id,
    required this.ruta,
    required this.compra,
    required this.valorRuta,
    required this.cantidadPersonas,
    required this.valorTotal,
  });

  factory DetalleCompra.fromJson(Map<String, dynamic> json) {
    return DetalleCompra(
      id: json['id'],
      ruta: RutaTuristica.fromJson(json['ruta']),
      compra: Compra.fromJson(json['compra']),
      valorRuta: json['valor_ruta'],
      cantidadPersonas: json['cantidad_personas'],
      valorTotal: json['valor_total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // Ahora tanto 'ruta' como 'compra' se envían como objetos simples
      // que solo contienen su ID, que es lo que Spring Boot espera para
      // establecer las relaciones @ManyToOne al crear un nuevo registro.
      'ruta': { 'id_rutaturistica': ruta.idRutaTuristica },
      'compra': { 'id': compra.id },
      'valor_ruta': valorRuta,
      'cantidad_personas': cantidadPersonas,
      'valor_total': valorTotal,
    };
  }
}
