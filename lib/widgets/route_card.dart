import 'package:flutter/material.dart';
import 'package:my_route_movil/models/ruta_turistica_model.dart';

class RouteCard extends StatelessWidget {
  final RutaTuristica ruta;
  final VoidCallback onTap;

  const RouteCard({super.key, required this.ruta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // --- PASO DE DEPURACIÓN ---
    // Imprimir la URL en la consola para verificarla.
    print('Intentando cargar imagen desde: ${ruta.imgUrl}');

    return Card(
      clipBehavior: Clip.antiAlias, // Para que la imagen respete los bordes redondeados
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar la imagen de la ruta
            SizedBox(
              height: 150,
              width: double.infinity, // Asegurarse que la imagen ocupe todo el ancho
              child: ruta.imgUrl.isNotEmpty
                  ? Image.network(
                      ruta.imgUrl,
                      fit: BoxFit.cover,
                      // Mostrar un indicador de carga mientras se baja la imagen
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      // Mostrar un icono de error si la imagen no se puede cargar
                      errorBuilder: (context, error, stackTrace) {
                        print('Error al cargar imagen: $error'); // Imprimir el error específico
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ruta.titulo,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ruta.descripcion,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 4),
                      Text('${ruta.cantDias} días', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      const Text('4.5', style: TextStyle(fontWeight: FontWeight.w600)), // Calificación de ejemplo
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
