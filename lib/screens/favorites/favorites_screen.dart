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
    final favoriteIds = await _favoritesService.getFavoriteRouteIds();
    if (favoriteIds.isEmpty) return [];
    final futureRutas = favoriteIds.map((id) => _rutaService.obtenerRutaTuristica(int.parse(id)));
    return await Future.wait(futureRutas);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<RutaTuristica>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final favoriteRutas = snapshot.data ?? [];

            // --- ESTADO VACÍO ---
            if (favoriteRutas.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 24),
                      Text('No hay favoritos', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Guarda tus rutas favoritas para acceder rápidamente',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(onPressed: () => context.go('/home'), child: const Text('Explorar rutas')),
                    ],
                  ),
                ),
              );
            }

            // --- LISTA DE FAVORITOS ---
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mis Favoritos', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${favoriteRutas.length} rutas guardadas', style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
                SliverList( 
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                       final ruta = favoriteRutas[index];
                       return Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                         child: RouteCard(
                           ruta: ruta,
                           onTap: () => context.push('/route/${ruta.idRutaTuristica}').then((_) => _loadFavorites()),
                         ),
                       );
                    },
                    childCount: favoriteRutas.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Favoritos es el tercer item
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/map');
          if (index == 3) context.go('/profile');
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}
