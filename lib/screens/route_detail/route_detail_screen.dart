import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/route_detail_model.dart';
import 'package:my_route_movil/services/favorites_service.dart';
import 'package:my_route_movil/services/reservation_service.dart';
import 'package:my_route_movil/services/ruta_turistica_service.dart';
import 'package:my_route_movil/widgets/reservation_dialog.dart';

class RouteDetailScreen extends StatefulWidget {
  final int routeId;
  const RouteDetailScreen({super.key, required this.routeId});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  // Servicios
  final _rutaService = RutaTuristicaService();
  final _favoritesService = FavoritesService();
  final _reservationService = ReservationService();

  // Estado
  late Future<RouteDetail> _detailFuture;
  bool _isFavorite = false;
  bool _isReserving = false;

  @override
  void initState() {
    super.initState();
    _detailFuture = _rutaService.getRouteDetail(widget.routeId);
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final isFav = await _favoritesService.isFavorite(widget.routeId);
    if (mounted) setState(() => _isFavorite = isFav);
  }

  void _toggleFavorite() async {
    await _favoritesService.toggleFavorite(widget.routeId);
    _checkIfFavorite();
  }

  Future<void> _handleReservation(RouteDetail routeDetail) async {
    final int? numberOfPeople = await showDialog<int>(
      context: context,
      builder: (context) => const ReservationDialog(),
    );

    if (numberOfPeople == null) return;

    setState(() => _isReserving = true);

    try {
      final double extras = routeDetail.ruta.extras.toDouble();
      final double puntosSum = routeDetail.puntosDeVisita.fold<double>(0.0, (sum, item) => sum + item.precio);
      final double totalCost = (extras + puntosSum) * numberOfPeople;

      await _reservationService.createReservation(
        ruta: routeDetail.ruta,
        cantidadPersonas: numberOfPeople,
        costoTotal: totalCost,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Reserva creada con éxito!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la reserva: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isReserving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RouteDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron detalles de la ruta.'));
          }

          final routeDetail = snapshot.data!;
          final ruta = routeDetail.ruta;
          final puntos = routeDetail.puntosDeVisita;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      // --- CORRECCIÓN ---
                      // Se quita el título de aquí para que no se sobreponga a la imagen.
                      // title: Text(ruta.titulo, style: const TextStyle(shadows: [Shadow(blurRadius: 10)])),
                      background: ruta.imgUrl.isNotEmpty
                          ? Image.network(
                              ruta.imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                const Center(child: Icon(Icons.image_not_supported, size: 100, color: Colors.white70)),
                            )
                          : Container(
                              color: Colors.grey[400],
                              child: const Icon(Icons.map, size: 100, color: Colors.white70),
                            ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                        color: _isFavorite ? Colors.redAccent : Colors.white,
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- CORRECCIÓN ---
                          // Se añade el título aquí, encima de la descripción.
                          Text(
                            ruta.titulo,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(ruta.descripcion, style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoChip(Icons.calendar_today, '${ruta.cantDias} días', context),
                              _buildInfoChip(Icons.attach_money, '${ruta.extras} (extras)', context),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text('Puntos de Visita', style: Theme.of(context).textTheme.headlineSmall),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final punto = puntos[index];
                        return ListTile(
                          leading: CircleAvatar(child: Icon(Icons.location_on, color: Theme.of(context).colorScheme.secondary)),
                          title: Text(punto.nombreActividad),
                          subtitle: Text(punto.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Text('\$${punto.precio.toStringAsFixed(2)}'),
                        );
                      },
                      childCount: puntos.length,
                    ),
                  ),
                   SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(onPressed: () => _handleReservation(routeDetail), child: const Text('Reservar Visita')),
                    )
                   )
                ],
              ),
              if (_isReserving)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final detail = await _detailFuture;
            if (detail.puntosDeVisita.isNotEmpty) {
              context.push('/map', extra: detail.puntosDeVisita);
            }
          } catch (_) {
            // Ignorar si la carga falla o manejar según convenga
          }
        },
        child: const Icon(Icons.map_outlined),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: Theme.of(context).primaryColor),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
