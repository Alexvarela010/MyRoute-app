import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_route_movil/models/route_detail_model.dart';

class BookingScreen extends StatefulWidget {
  final RouteDetail routeDetail;
  const BookingScreen({super.key, required this.routeDetail});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _personCount = 1;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _updatePersonCount(int change) {
    setState(() {
      if (_personCount + change >= 1) _personCount += change;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final routePrice = widget.routeDetail.ruta.extras;
    final total = routePrice * _personCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar ruta'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        bottom: PreferredSize(child: Text('Completa los detalles de tu reserva', style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600])), preferredSize: const Size.fromHeight(20.0)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRouteSummaryCard(widget.routeDetail, textTheme),
            const SizedBox(height: 24),
            _buildDatePicker(context, textTheme),
            const SizedBox(height: 20),
            _buildTimePicker(context, textTheme),
            const SizedBox(height: 20),
            _buildPersonSelector(textTheme),
            const SizedBox(height: 24),
            _buildPriceSummary(routePrice, total, colorScheme, textTheme),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookingFooter(context),
    );
  }

  Widget _buildRouteSummaryCard(RouteDetail detail, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(detail.ruta.imgUrl, width: 80, height: 80, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail.ruta.titulo, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16), const SizedBox(width: 4), Text('4.8', style: textTheme.bodyMedium)])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, TextTheme textTheme) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Fecha de la visita'),
        child: Text(DateFormat.yMMMMd('es').format(_selectedDate), style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, TextTheme textTheme) {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Hora de inicio'),
        child: Text(_selectedTime.format(context), style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPersonSelector(TextTheme textTheme) {
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Personas'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => _updatePersonCount(-1)),
          Text('$_personCount', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _updatePersonCount(1)),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(double price, double total, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [colorScheme.primary.withOpacity(0.1), colorScheme.secondary.withOpacity(0.1)]), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Precio por persona'), Text('\$${price.toStringAsFixed(0)}')]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Personas'), Text('x$_personCount')]),
          const Divider(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), Text('\$${total.toStringAsFixed(0)}', style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold))]),
        ],
      ),
    );
  }

  Widget _buildBookingFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          // --- MODIFICACIÓN CLAVE ---
          onPressed: () {
            // Aquí iría la lógica para enviar la reserva al backend.
            // Por ahora, simplemente navegamos a la pantalla de éxito.
            context.push('/booking-success');
          },
          child: const Text('Confirmar reserva'),
        ),
      ),
    );
  }
}
