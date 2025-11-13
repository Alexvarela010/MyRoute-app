import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _favoritesKey = 'favorite_routes';

  // Obtener la lista de IDs de rutas favoritas
  Future<List<String>> getFavoriteRouteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Comprobar si una ruta es favorita
  Future<bool> isFavorite(int routeId) async {
    final ids = await getFavoriteRouteIds();
    return ids.contains(routeId.toString());
  }

  // Añadir o quitar una ruta de favoritos
  Future<void> toggleFavorite(int routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getFavoriteRouteIds();
    
    final idAsString = routeId.toString();

    if (ids.contains(idAsString)) {
      ids.remove(idAsString);
    } else {
      ids.add(idAsString);
    }

    await prefs.setStringList(_favoritesKey, ids);
  }
}
