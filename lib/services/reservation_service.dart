import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:my_route_movil/models/cliente_model.dart';
import 'package:my_route_movil/models/compra_model.dart';
import 'package:my_route_movil/models/detalle_compra_model.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';
import 'package:my_route_movil/models/user_info_model.dart';
import 'package:my_route_movil/services/cliente_service.dart';
import 'package:my_route_movil/services/compra_service.dart';
import 'package:my_route_movil/services/detalle_compra_service.dart';
import 'package:my_route_movil/services/user_service.dart';

class ReservationService {
  final UserService _userService = UserService();
  final ClienteService _clienteService = ClienteService();
  final CompraService _compraService = CompraService();
  final DetalleCompraService _detalleCompraService = DetalleCompraService();

  Future<void> createReservation({
    required RutaTuristica ruta,
    required int cantidadPersonas,
    required double costoTotal,
  }) async {
    try {
      // 1. Obtener el usuario y el cliente actual
      final UserInfo userInfo = await _userService.getMe();
      final Cliente cliente = await _clienteService.obtenerCliente(userInfo.cedula);

      // 2. Crear el objeto Compra
      final newCompra = Compra(
        id: 0, // El backend lo genera
        usuario: userInfo,
        cliente: cliente,
        fecha: DateTime.now(),
        totalRuta: costoTotal, // El costo de la ruta es el total en este caso
        totalOtrosCargos: 0,
        total: costoTotal,
      );

      // 3. Guardar la Compra y obtener el objeto creado con su ID
      final createdCompra = await _compraService.crearCompra(newCompra);
      
      // --- PASO DE DEPURACIÓN ---
      // Imprimimos el objeto Compra recibido del backend para inspeccionarlo.
      if (kDebugMode) {
        print('Objeto Compra creado y recibido del backend:');
        print(jsonEncode(createdCompra.toJson()));
      }

      // 4. Crear el objeto DetalleCompra
      DetalleCompra newDetalle = DetalleCompra(
        id: 0, // El backend lo genera
        ruta: ruta,
        compra: createdCompra,
        valorRuta: (costoTotal / cantidadPersonas).round(), // Valor por persona
        cantidadPersonas: cantidadPersonas,
        valorTotal: costoTotal.round(),
      );
      print('Objeto Detalle Compra creado y recibido del backend:');
      print(newDetalle.toJson());


      // 5. Guardar el DetalleCompra
      final detalleCompra=await _detalleCompraService.crearDetalleCompra(newDetalle);
      if (kDebugMode) {
        print('Objeto Detalle Compra creado y recibido del backend:');
        print(jsonEncode(detalleCompra.toJson()));
      }
    } catch (e) {
      // Re-lanzar la excepción para que la UI pueda manejarla
      throw Exception('Error al crear la reservación: $e');
    }
  }
}
