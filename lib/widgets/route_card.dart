import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';

class RouteCard extends StatefulWidget {
  final RutaTuristica ruta;
  final VoidCallback onTap;

  const RouteCard({super.key, required this.ruta, required this.onTap});

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  bool _isFavorite = false; // Estado local para el favorito
  bool _isPressed = false; // Estado para la animación de pulsación

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap(); // Ejecutar la acción de navegación
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Card(
          clipBehavior: Clip.antiAlias, // Importante para que el Stack respete los bordes
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECCIÓN DE LA IMAGEN CON ELEMENTOS FLOTANTES ---
              SizedBox(
                height: 192, // h-48 aprox.
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Imagen de fondo
                    Image.network(
                      widget.ruta.imgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported, size: 50)),
                    ),
                    // Badge de categoría (arriba a la izquierda)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
                            child: const Text('Cultura', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                    // Botón de favorito (arriba a la derecha)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: IconButton(
                          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? colorScheme.error : colorScheme.primary),
                          onPressed: () => setState(() => _isFavorite = !_isFavorite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // --- SECCIÓN DE INFORMACIÓN ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.ruta.titulo, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    _buildInfoRow(Icons.location_on_outlined, widget.ruta.ciudad?.ciudad ?? 'Ubicación no disponible'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoRow(Icons.access_time_outlined, '${widget.ruta.cantDias} días'),
                        _buildInfoRow(Icons.attach_money_outlined, widget.ruta.extras.toStringAsFixed(2)),
                        _buildInfoRow(Icons.star, '4.8', iconColor: Colors.amber),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Pequeño widget helper para las filas de información
  Widget _buildInfoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
