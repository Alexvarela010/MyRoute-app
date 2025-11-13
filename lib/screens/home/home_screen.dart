import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';
import 'package:my_route_movil/services/ruta_turistica_service.dart';
import 'package:my_route_movil/widgets/route_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<RutaTuristica>> _rutasFuture;
  final _rutaService = RutaTuristicaService();

  @override
  void initState() {
    super.initState();
    _loadRutas();
  }

  void _loadRutas() {
    setState(() {
      _rutasFuture = _rutaService.listarRutasTuristicas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Rutas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<RutaTuristica>>(
        future: _rutasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las rutas: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay rutas disponibles.'));
          }

          final rutas = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => _loadRutas(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: rutas.length,
              itemBuilder: (context, index) {
                final ruta = rutas[index];
                return RouteCard(
                  ruta: ruta,
                  onTap: () {
                    context.push('/route/${ruta.idRutaTuristica}').then((_) => _loadRutas());
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/create-route').then((_) => _loadRutas());
        },
        label: const Text('Crear Ruta'),
        icon: const Icon(Icons.add_location_alt_outlined),
      ),
    );
  }
}
