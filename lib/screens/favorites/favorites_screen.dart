import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';
import 'package:my_route_movil/services/favorites_service.dart';
import 'package:my_route_movil/services/ruta_turistica_service.dart';
import 'package:my_route_movil/widgets/route_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favoritesService = FavoritesService();
  final _rutaService = RutaTuristicaService();
  late Future<List<RutaTuristica>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = _getFavoriteRoutes();
    });
  }

  Future<List<RutaTuristica>> _getFavoriteRoutes() async {
    // 1. Obtener los IDs de las rutas favoritas
    final favoriteIds = await _favoritesService.getFavoriteRouteIds();

    if (favoriteIds.isEmpty) {
      return []; // No hay favoritos, devolver lista vacía
    }

    // 2. Para cada ID, crear un futuro que obtenga los datos de la ruta
    final List<Future<RutaTuristica>> futureRutas = favoriteIds
        .map((id) => _rutaService.obtenerRutaTuristica(int.parse(id)))
        .toList();

    // 3. Esperar a que todas las llamadas a la API terminen
    final List<RutaTuristica> rutas = await Future.wait(futureRutas);

    return rutas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Rutas Favoritas'),
      ),
      body: FutureBuilder<List<RutaTuristica>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar favoritos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aún no tienes rutas favoritas.\n¡Explora y añade algunas!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final favoriteRutas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: favoriteRutas.length,
            itemBuilder: (context, index) {
              final ruta = favoriteRutas[index];
              return RouteCard(
                ruta: ruta,
                onTap: () {
                  // Navegar al detalle y recargar la lista de favoritos al volver
                  context.push('/route/${ruta.idRutaTuristica}').then((_) => _loadFavorites());
                },
              );
            },
          );
        },
      ),
    );
  }
}
