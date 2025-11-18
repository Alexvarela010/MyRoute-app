import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';
import 'package:my_route_movil/services/favorites_service.dart';
import 'package:my_route_movil/services/ruta_turistica_service.dart';

import '../../models/route_detail_model.dart';

class RouteDetailScreen extends StatefulWidget {
  final int routeId;
  const RouteDetailScreen({super.key, required this.routeId});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  final _rutaService = RutaTuristicaService();
  final _favoritesService = FavoritesService();

  late Future<RouteDetail> _detailFuture;
  bool _isFavorite = false;

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: FutureBuilder<RouteDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('No se pudo cargar la ruta.'));
          }

          final routeDetail = snapshot.data!;
          final ruta = routeDetail.ruta;
          final puntos = routeDetail.puntosDeVisita;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(expandedHeight: 256, stretch: true, pinned: true, backgroundColor: colorScheme.background, elevation: 0, automaticallyImplyLeading: false, flexibleSpace: FlexibleSpaceBar(background: Image.network(ruta.imgUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported))))),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ruta.titulo, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(children: [Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]), const SizedBox(width: 4), Text(ruta.ciudad?.ciudad ?? 'Ubicación', style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]))]),
                          const SizedBox(height: 16),
                          _buildStatsCard(ruta, textTheme, colorScheme),
                          const SizedBox(height: 24),
                          Text('Descripción', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(ruta.descripcion, style: textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                          const SizedBox(height: 24),
                          Text('Puntos de Interés', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverList.builder(itemCount: puntos.length, itemBuilder: (context, index) {
                      final punto = puntos[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor)),
                        child: Row(children: [CircleAvatar(backgroundColor: colorScheme.primary, child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), const SizedBox(width: 16), Expanded(child: Text(punto.nombreActividad, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)))]),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
              _buildFloatingButtons(context),
            ],
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<RouteDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return _buildBookingFooter(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFloatingButton(context, Icons.arrow_back, () => context.pop()),
          Row(
            children: [
              _buildFloatingButton(context, Icons.share_outlined, () {}), 
              const SizedBox(width: 8),
              _buildFloatingButton(context, _isFavorite ? Icons.favorite : Icons.favorite_border, _toggleFavorite, iconColor: _isFavorite ? Colors.redAccent : null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context, IconData icon, VoidCallback onPressed, {Color? iconColor}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.3),
          child: IconButton(
            icon: Icon(icon, color: iconColor ?? Colors.black87),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(RutaTuristica ruta, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.access_time_outlined, '${ruta.cantDias} días', textTheme),
          _buildStatItem(Icons.attach_money, ruta.extras.toStringAsFixed(0), textTheme),
          _buildStatItem(Icons.star_border, '4.8', textTheme, iconColor: Colors.amber),
        ],
      ),
    );
  }

  Column _buildStatItem(IconData icon, String value, TextTheme textTheme, {Color? iconColor}) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? Colors.grey[600]),
        const SizedBox(height: 4),
        Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBookingFooter(BuildContext context, RouteDetail routeDetail) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, border: Border(top: BorderSide(color: Theme.of(context).dividerColor))),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/booking', extra: routeDetail),
            child: const Text('Reservar ahora'),
          ),
        ),
      );
  }
}
