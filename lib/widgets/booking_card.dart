import 'package:flutter/material.dart';
import 'package:my_route_movil/models/detalle_compra_model.dart'; // CORREGIDO: Modelo correcto

class BookingCard extends StatelessWidget {
  // CORREGIDO: Renombrado para mayor claridad
  final DetalleCompra reservationDetail;
  final VoidCallback onTap;

  const BookingCard({super.key, required this.reservationDetail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // CORREGIDO: Acceder a los datos desde el modelo DetalleCompra
    final ruta = reservationDetail.ruta;
    final compra = reservationDetail.compra;

    // Determinar el estado de la reserva
    final now = DateTime.now();
    final reservationDate = compra.fecha; 
    final status = reservationDate!.isAfter(now) ? 'upcoming' : 'completed';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 140,
              child: Image.network(
                ruta.imgUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusBadge(status, colorScheme),
                    const SizedBox(height: 8),
                    Text(
                      ruta.titulo,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // CORREGIDO: Acceder a los datos desde los modelos correctos
                    _buildInfoRow(Icons.location_on_outlined, ruta.ciudad?.ciudad ?? 'Ubicación', textTheme),
                    const SizedBox(height: 4),
                    _buildInfoRow(Icons.calendar_today_outlined, reservationDate.toIso8601String().split('T').first, textTheme),
                    const SizedBox(height: 4),
                    _buildInfoRow(Icons.group_outlined, '${reservationDetail.cantidadPersonas} personas', textTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, TextTheme textTheme) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildStatusBadge(String status, ColorScheme colorScheme) {
    final Map<String, dynamic> statusInfo = {
      'upcoming': {'text': 'Próxima', 'color': colorScheme.secondary.withOpacity(0.2), 'textColor': colorScheme.secondary},
      'completed': {'text': 'Completada', 'color': colorScheme.primary.withOpacity(0.2), 'textColor': colorScheme.primary},
      'cancelled': {'text': 'Cancelada', 'color': colorScheme.error.withOpacity(0.2), 'textColor': colorScheme.error},
    };
    final currentStatus = statusInfo[status] ?? statusInfo['completed']!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: currentStatus['color'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(currentStatus['text'], style: TextStyle(color: currentStatus['textColor'], fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}
