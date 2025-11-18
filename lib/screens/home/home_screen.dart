import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';
import 'package:my_route_movil/services/ruta_turistica_service.dart';
import 'package:my_route_movil/widgets/route_card.dart'; // Asumimos que este widget será rediseñado

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _rutaService = RutaTuristicaService();
  late Future<List<RutaTuristica>> _rutasFuture;
  
  // Estado para los filtros
  final _searchController = TextEditingController();
  final Set<String> _selectedCategories = {}; // Aquí guardaremos las categorías seleccionadas

  @override
  void initState() {
    super.initState();
    _rutasFuture = _rutaService.listarRutasTuristicas();
    _searchController.addListener(() => setState(() {})); // Redibuja al escribir
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- Header y Búsqueda ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saludo y Notificaciones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hola, viajero', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                            Text('Explora el mundo', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).dividerColor)
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_none_outlined, color: Colors.grey),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Barra de búsqueda
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(hintText: 'Buscar rutas...', prefixIcon: Icon(Icons.search)),
                    ),
                    const SizedBox(height: 20),
                    // Chips de categorías
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildInterestChip('Cultura', Icons.museum_outlined, _selectedCategories.contains('Cultura')),
                          const SizedBox(width: 10),
                          _buildInterestChip('Gastronomía', Icons.restaurant_outlined, _selectedCategories.contains('Gastronomía')),
                           const SizedBox(width: 10),
                          _buildInterestChip('Naturaleza', Icons.park_outlined, _selectedCategories.contains('Naturaleza')),
                        ],
                      ), 
                    ),
                  ],
                ),
              ),
            ),
            // --- Título de la sección de rutas ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('Rutas recomendadas', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                     TextButton(onPressed: (){}, child: Text('Ver todas', style: TextStyle(color: colorScheme.primary)))
                  ],
                ),
              ),
            ),
            // --- Lista de Rutas ---
            FutureBuilder<List<RutaTuristica>>(
              future: _rutasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return SliverFillRemaining(child: Center(child: Text('Error: ${snapshot.error}')));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverFillRemaining(child: Center(child: Text('No hay rutas disponibles.')));
                }

                // Lógica de filtrado
                final allRutas = snapshot.data!;
                final filteredRutas = allRutas.where((ruta) {
                  final searchLower = _searchController.text.toLowerCase();
                  final matchesSearch = ruta.titulo.toLowerCase().contains(searchLower) || ruta.descripcion.toLowerCase().contains(searchLower);
                  // Asumimos que el modelo `RutaTuristica` tendrá una propiedad `categoria`
                  // final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(ruta.categoria);
                  return matchesSearch; //&& matchesCategory;
                }).toList();

                return SliverList( 
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                       final ruta = filteredRutas[index];
                       return Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                         child: RouteCard(
                           ruta: ruta,
                           onTap: () => context.push('/route/${ruta.idRutaTuristica}'),
                         ),
                       );
                    },
                    childCount: filteredRutas.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // --- Barra de Navegación Inferior ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, //  Home es el primer item
        onTap: (index) {
          if (index == 1) context.go('/map'); // Asumiendo que /map es la ruta del mapa
          if (index == 2) context.go('/favorites');
          if (index == 3) context.go('/profile');
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
  
  // Widget para construir los chips de interés
  Widget _buildInterestChip(String label, IconData icon, bool isSelected) {
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
      selected: isSelected,
      onSelected: (bool selected) => _toggleCategory(label),
      shape: const StadiumBorder(),
      showCheckmark: false,
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
