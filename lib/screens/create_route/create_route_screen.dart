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
  final _daysController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Controlador para la URL de la imagen

  // Servicios
  final _puntoVisitaService = PuntoVisitaService();
  final _rutaTuristicaService = RutaTuristicaService();
  final _rutaPuntoService = RutaPuntoService();

  // Estado
  late Future<List<PuntoVisita>> _puntosFuture;
  final Set<PuntoVisita> _selectedPuntos = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _puntosFuture = _puntoVisitaService.listarPuntosVisita();
  }

  Future<void> _saveRoute() async {
    if (!_formKey.currentState!.validate() || _selectedPuntos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos y selecciona al menos un punto de visita.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Crear el objeto RutaTuristica
      final newRoute = RutaTuristica(
        idRutaTuristica: 0, // El backend asignará el ID
        titulo: _titleController.text,
        descripcion: _descriptionController.text,
        fechaCreacion: DateTime.now(),
        cantDias: int.parse(_daysController.text),
        estado: true,
        extras: 0, // Valor de ejemplo
        imgUrl: _imageUrlController.text, // Añadir la URL de la imagen
      );

      // 2. Guardar la RutaTuristica y obtener el objeto creado con su ID
      final createdRoute = await _rutaTuristicaService.crearRutaTuristica(newRoute);

      // 3. Crear todas las asociaciones Ruta-Punto en paralelo
      final List<Future<void>> futureAssociations = [];
      for (var punto in _selectedPuntos) {
        final newRutaPunto = RutaPunto(
          idRutaPunto: 0, // El backend asigna el ID
          actividad: punto,
          ruta: createdRoute,
        );
        futureAssociations.add(_rutaPuntoService.crearRutaPunto(newRutaPunto));
      }

      await Future.wait(futureAssociations);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Ruta creada con éxito!'), backgroundColor: Colors.green),
        );
        context.pop(); // Volver a la pantalla anterior (HomeScreen)
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la ruta: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Ruta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalles de la Ruta', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título de la Ruta'), validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descripción'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _daysController, decoration: const InputDecoration(labelText: 'Cantidad de Días'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'URL de la Imagen'), validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 24),
              Text('Selecciona los Puntos de Visita', style: Theme.of(context).textTheme.headlineSmall),
              const Divider(),
              _buildPuntosDeVisitaList(),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _saveRoute, child: const Text('Guardar Ruta')),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPuntosDeVisitaList() {
    return FutureBuilder<List<PuntoVisita>>(
      future: _puntosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No se pudieron cargar los puntos de visita.');
        }

        final puntos = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true, // Para que funcione dentro de un SingleChildScrollView
          physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll de esta lista
          itemCount: puntos.length,
          itemBuilder: (context, index) {
            final punto = puntos[index];
            final isSelected = _selectedPuntos.contains(punto);
            return CheckboxListTile(
              title: Text(punto.nombreActividad),
              subtitle: Text(punto.ciudad.ciudad),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedPuntos.add(punto);
                  } else {
                    _selectedPuntos.remove(punto);
                  }
                });
              },
            );
          },
        );
      },
    );
  }
}
