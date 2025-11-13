import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_route_movil/models/punto_visita_model.dart';

class MapScreen extends StatefulWidget {
  final List<PuntoVisita> puntosDeVisita;
  const MapScreen({super.key, required this.puntosDeVisita});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    for (var punto in widget.puntosDeVisita) {
      try {
        // Asumimos que `urlmaps` es un string "lat,lng"
        final parts = punto.urlmaps.split(',');
        final lat = double.parse(parts[0].trim());
        final lng = double.parse(parts[1].trim());

        final marker = Marker(
          markerId: MarkerId(punto.id.toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: punto.nombreActividad,
            snippet: punto.descripcion,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );
        _markers.add(marker);
      } catch (e) {
        // Si el formato de lat,lng es incorrecto, simplemente ignoramos este punto.
        print('Error parsing coordinates for ${punto.nombreActividad}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcular la posición inicial del mapa (el primer punto o una ubicación por defecto)
    final initialPosition = _markers.isNotEmpty
        ? _markers.first.position
        : const LatLng(4.60971, -74.08175); // Coordenadas de Bogotá por defecto

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de la Ruta'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12.0,
        ),
        markers: _markers,
      ),
    );
  }
}
