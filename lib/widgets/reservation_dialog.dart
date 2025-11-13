import 'package:flutter/material.dart';

class ReservationDialog extends StatefulWidget {
  const ReservationDialog({super.key});

  @override
  State<ReservationDialog> createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  final _controller = TextEditingController(text: '1');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar Reserva'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Para cuántas personas deseas reservar esta ruta?'),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de personas',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Introduce un número válido';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cierra el diálogo sin devolver nada
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Cierra el diálogo y devuelve el número de personas
              Navigator.of(context).pop(int.parse(_controller.text));
            }
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
