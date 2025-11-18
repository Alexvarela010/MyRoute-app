import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/detalle_compra_model.dart'; // CORREGIDO: Modelo correcto
import 'package:my_route_movil/services/detalle_compra_service.dart'; // CORREGIDO: Servicio correcto
import 'package:my_route_movil/widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  // CORREGIDO: Usar el servicio de detalle de compra
  final DetalleCompraService _detalleCompraService = DetalleCompraService();
  late Future<List<DetalleCompra>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    // CORREGIDO: Llamar al método correcto para listar todas las reservas
    _reservationsFuture = _detalleCompraService.listarDetallesCompra(); 
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      // CORREGIDO: El FutureBuilder ahora espera una lista de DetalleCompra
      body: FutureBuilder<List<DetalleCompra>>(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las reservas: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aún no tienes ninguna reserva.'));
          }

          final reservations = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Text('${reservations.length} reservas totales', style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
                ),
              ),
              SliverList.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    // CORREGIDO: Pasar el objeto DetalleCompra al BookingCard
                    child: BookingCard(
                      reservationDetail: reservation,
                      onTap: () {
                        // La navegación sigue funcionando porque el modelo DetalleCompra contiene la Ruta
                        context.push('/route/${reservation.ruta.idRutaTuristica}');
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
