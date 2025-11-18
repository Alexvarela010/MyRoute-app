import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/punto_visita_model.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';
import 'package:my_route_movil/models/ruta_punto_model.dart';
import 'package:my_route_movil/services/punto_visita_service.dart';
import 'package:my_route_movil/services/ruta_turistica_service.dart';
import 'package:my_route_movil/services/ruta_punto_service.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _daysController = TextEditingController(text: '1');
  final _imageUrlController = TextEditingController();

  final _puntoVisitaService = PuntoVisitaService();
  final _rutaTuristicaService = RutaTuristicaService();
  final _rutaPuntoService = RutaPuntoService();

  final List<PuntoVisita> _selectedPuntos = [];
  bool _isLoading = false;

  Future<void> _saveRoute() async {
    if (!_formKey.currentState!.validate() || _selectedPuntos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos y añade al menos un punto de visita.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final newRoute = RutaTuristica(
        idRutaTuristica: 0,
        titulo: _titleController.text,
        descripcion: _descriptionController.text,
        fechaCreacion: DateTime.now(),
        cantDias: int.tryParse(_daysController.text) ?? 1,
        estado: true,
        extras: 0, // Se puede ajustar si se añade un campo para esto
        imgUrl: _imageUrlController.text,
      );
      final createdRoute = await _rutaTuristicaService.crearRutaTuristica(newRoute);
      final associations = _selectedPuntos.map((punto) {
        final newRutaPunto = RutaPunto(idRutaPunto: 0, actividad: punto, ruta: createdRoute);
        return _rutaPuntoService.crearRutaPunto(newRutaPunto);
      });
      await Future.wait(associations);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Ruta creada con éxito!'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la ruta: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Nueva Ruta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(hintText: 'Título de la ruta'), validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 20),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(hintText: 'Descripción de la ruta'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: TextFormField(controller: _daysController, decoration: const InputDecoration(hintText: 'Días'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Requerido' : null)),
                const SizedBox(width: 20),
                Expanded(flex: 3, child: TextFormField(controller: _imageUrlController, decoration: const InputDecoration(hintText: 'URL de la imagen'), validator: (v) => v!.isEmpty ? 'Requerido' : null)),
              ]),
              const SizedBox(height: 32),
              Text('Puntos de Interés', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildSelectedPointsList(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showAddPointsModal,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir punto de interés'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isLoading 
          ? const LinearProgressIndicator() 
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: ElevatedButton(onPressed: _saveRoute, child: const Text('Guardar Ruta')), 
            ),
    );
  }

  Widget _buildSelectedPointsList() {
    if (_selectedPuntos.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Aún no has añadido puntos.', style: TextStyle(color: Colors.grey))));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedPuntos.length,
      itemBuilder: (context, index) {
        final punto = _selectedPuntos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(punto.nombreActividad),
            subtitle: Text(punto.ciudad.ciudad),
            trailing: IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent), onPressed: () => setState(() => _selectedPuntos.remove(punto))),
          ),
        );
      },
    );
  }

  void _showAddPointsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FutureBuilder<List<PuntoVisita>>(
          future: _puntoVisitaService.listarPuntosVisita(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(heightFactor: 5, child: CircularProgressIndicator());
            final allPoints = snapshot.data!;
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              expand: false,
              builder: (_, controller) => Column(
                children: [
                  Padding(padding: const EdgeInsets.all(16), child: Text('Selecciona un punto', style: Theme.of(context).textTheme.titleLarge)),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: allPoints.length,
                      itemBuilder: (_, index) {
                        final punto = allPoints[index];
                        final isAlreadySelected = _selectedPuntos.any((p) => p.id == punto.id);
                        return ListTile(
                          title: Text(punto.nombreActividad),
                          subtitle: Text(punto.ciudad.ciudad),
                          onTap: isAlreadySelected ? null : () => _showPointDetailsDialog(punto),
                          trailing: isAlreadySelected ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.add_circle_outline),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPointDetailsDialog(PuntoVisita punto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(punto.nombreActividad),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(punto.descripcion, maxLines: 4, overflow: TextOverflow.ellipsis),
            const Divider(height: 24),
            Row(children: [const Icon(Icons.location_city_outlined, size: 16), const SizedBox(width: 8), Text(punto.ciudad.ciudad)]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.attach_money_rounded, size: 16), const SizedBox(width: 8), Text(punto.precio.toStringAsFixed(0))]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => _addPoint(punto), child: const Text('Agregar')),
        ],
      ),
    );
  }

  void _addPoint(PuntoVisita punto) {
    setState(() => _selectedPuntos.add(punto));
    Navigator.of(context).pop(); // Cierra el dialog
    // No cerramos el bottom sheet para que puedan seguir añadiendo puntos.
  }
}
