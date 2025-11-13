import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/cliente_model.dart';
import 'package:my_route_movil/models/user_info_model.dart';
import 'package:my_route_movil/services/auth_service.dart';
import 'package:my_route_movil/services/cliente_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _clienteService = ClienteService(); // Servicio para crear el cliente
  bool _isLoading = false;

  // Controladores para todos los campos del formulario
  final _cedulaController = TextEditingController();
  final _emailController = TextEditingController();
  final _nombreController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _telefonoController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Crear el objeto UserInfo con los datos del formulario
      final newUser = UserInfo(
        cedula: _cedulaController.text,
        email: _emailController.text,
        nombre: _nombreController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        fechaNacimiento: DateTime.parse(_fechaNacimientoController.text),
        roles: 'ROLE_USER', // Rol por defecto para nuevos usuarios
        activo: true,
        telefono: _telefonoController.text,
        infoAdicional: '',
        telPersonaContacto: '',
        nombrePersonaContacto: '',
        tipoSangre: '',
      );

      // 2. Crear el UserInfo en el backend
      await _authService.register(newUser);

      // 3. Crear el objeto Cliente con los mismos datos
      final newClient = Cliente(
        cedula: newUser.cedula,
        username: newUser.username,
        password: newUser.password,
        nombre: newUser.nombre,
        correo: newUser.email,
        telefono: newUser.telefono,
        fechaNacimiento: newUser.fechaNacimiento,
        activo: true,
        usuario: newUser, // ¡Importante! Asociar el UserInfo creado
        nombrePersonaContacto: '', // Estos campos pueden llenarse después
        telefonoPersonaContacto: '',
      );

      // 4. Crear el Cliente en el backend
      await _clienteService.crearCliente(newClient);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Usuario registrado con éxito! Por favor, inicia sesión.'), backgroundColor: Colors.green),
        );
        // Si el registro es exitoso, volver al login
        context.pop();
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en el registro: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
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
        title: const Text('Crear Cuenta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _cedulaController, decoration: const InputDecoration(labelText: 'Cédula'), validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre Completo'), validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Nombre de Usuario'), validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Correo Electrónico'), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty || !v.contains('@') ? 'Email inválido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _telefonoController, decoration: const InputDecoration(labelText: 'Teléfono'), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(labelText: 'Fecha de Nacimiento (YYYY-MM-DD)', prefixIcon: Icon(Icons.calendar_today)),
                keyboardType: TextInputType.datetime,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Quitar foco
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _fechaNacimientoController.text = pickedDate.toIso8601String().split('T').first;
                  }
                },
              ),
              const SizedBox(height: 30),
              _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _register, child: const Text('Registrarse')),
            ],
          ),
        ),
      ),
    );
  }
}
