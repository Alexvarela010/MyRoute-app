import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_route_movil/models/punto_visita_model.dart';
import 'package:my_route_movil/services/punto_visita_service.dart'; // Importamos el servicio

class MapScreen extends StatefulWidget {
  // CORREGIDO: La lista de puntos ahora es opcional
  final List<PuntoVisita>? puntosDeVisita;
  const MapScreen({super.key, this.puntosDeVisita});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  PuntoVisita? _selectedPunto;
  
  // CORREGIDO: Usaremos un Future para manejar la carga de puntos
  late Future<List<PuntoVisita>> _pointsFuture;
  final PuntoVisitaService _puntoVisitaService = PuntoVisitaService();

  @override
  void initState() {
    super.initState();
    // CORREGIDO: Si nos pasan puntos, los usamos. Si no, los vamos a buscar todos.
    if (widget.puntosDeVisita != null && widget.puntosDeVisita!.isNotEmpty) {
      _pointsFuture = Future.value(widget.puntosDeVisita!);
    } else {
      _pointsFuture = _puntoVisitaService.listarPuntosVisita();
    }
  }

  void _createMarkers(List<PuntoVisita> puntos) {
    _markers.clear();
    for (var punto in puntos) {
      try {
        final parts = punto.urlmaps.split(',');
        final lat = double.parse(parts[0].trim());
        final lng = double.parse(parts[1].trim());

        _markers.add(Marker(
          markerId: MarkerId(punto.id.toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: punto.nombreActividad),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () => setState(() => _selectedPunto = punto),
        ));
      } catch (e) {
        print('Error parsing coordinates for ${punto.nombreActividad}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CORREGIDO: Envolvemos todo en un FutureBuilder
      body: FutureBuilder<List<PuntoVisita>>(
        future: _pointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron puntos de interés.'));
          }

          final puntos = snapshot.data!;
          _createMarkers(puntos);

          final initialPosition = _markers.isNotEmpty
              ? _markers.first.position
              : const LatLng(4.60971, -74.08175);

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: initialPosition, zoom: 12.0),
                markers: _markers,
                onTap: (_) => setState(() => _selectedPunto = null),
              ),
              _buildFloatingHeader(context),
              if (_selectedPunto != null) _buildFloatingRouteCard(context, _selectedPunto!),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 2) context.go('/favorites');
          if (index == 3) context.go('/profile');
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Row(
        children: [
          _buildFloatingButton(context, Icons.arrow_back, () => context.pop()),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar ubicación...',
                prefixIcon: Icon(Icons.search, size: 20),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.5),
          child: IconButton(icon: Icon(icon, color: Colors.black87), onPressed: onPressed),
        ),
      ),
    );
  }

  Widget _buildFloatingRouteCard(BuildContext context, PuntoVisita punto) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: GestureDetector(
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network('https://via.placeholder.com/80', width: 80, height: 80, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(punto.nombreActividad, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(punto.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('Precio: \$${punto.precio.toStringAsFixed(0)}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
