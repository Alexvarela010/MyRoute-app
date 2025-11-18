import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/user_info_model.dart';
import 'package:my_route_movil/services/auth_service.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  // --- CORREGIDO: Añadimos todos los controladores necesarios ---
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // --- CORREGIDO: Usamos los datos reales de los controladores ---
      final newUser = UserInfo(
        cedula: _cedulaController.text,
        email: _emailController.text,
        nombre: _nombreController.text,
        username: _emailController.text, // Usamos el email como username inicial
        password: _passwordController.text,
        fechaNacimiento: DateFormat('yyyy-MM-dd').parse(_fechaNacimientoController.text),
        roles: 'ROLE_USER',
        activo: true,
        telefono: _telefonoController.text, 
        infoAdicional: '', // Estos campos se pueden pedir después
        telPersonaContacto: '',
        nombrePersonaContacto: '',
        tipoSangre: '',
      );

      await _authService.register(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Registro exitoso! Ya puedes iniciar sesión.'), backgroundColor: Colors.green),
        );
        context.go('/login');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el registro: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error),
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), backgroundColor: Colors.transparent),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crear cuenta', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Regístrate y comienza a explorar', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.6))),
                const SizedBox(height: 40),

                // --- CORREGIDO: Añadimos los campos que faltaban ---
                TextFormField(controller: _nombreController, decoration: const InputDecoration(hintText: 'Nombre completo'), validator: (v) => v!.isEmpty ? 'El nombre es requerido' : null),
                const SizedBox(height: 20),
                TextFormField(controller: _cedulaController, decoration: const InputDecoration(hintText: 'Cédula de identidad'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'La cédula es requerida' : null),
                const SizedBox(height: 20),
                TextFormField(controller: _emailController, decoration: const InputDecoration(hintText: 'Correo electrónico'), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty || !v.contains('@') ? 'Introduce un email válido' : null),
                const SizedBox(height: 20),
                TextFormField(controller: _telefonoController, decoration: const InputDecoration(hintText: 'Número de teléfono'), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'El teléfono es requerido' : null),
                const SizedBox(height: 20),
                // Campo de fecha de nacimiento con selector
                TextFormField(
                  controller: _fechaNacimientoController,
                  decoration: const InputDecoration(hintText: 'Fecha de nacimiento', prefixIcon: Icon(Icons.calendar_today_outlined)),
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1920), lastDate: DateTime.now());
                    if (pickedDate != null) {
                      _fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  validator: (v) => v!.isEmpty ? 'La fecha es requerida' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(controller: _passwordController, decoration: const InputDecoration(hintText: 'Contraseña'), obscureText: true, validator: (v) => v!.isEmpty || v.length < 6 ? 'La contraseña debe tener al menos 6 caracteres' : null),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(hintText: 'Confirmar contraseña'),
                  obscureText: true,
                  validator: (v) => v != _passwordController.text ? 'Las contraseñas no coinciden' : null,
                ),
                const SizedBox(height: 40),
                
                _isLoading ? const Center(child: CircularProgressIndicator()) : SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _register, child: const Text('Registrarse'))),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¿Ya tienes cuenta? ', style: textTheme.bodyMedium),
            TextButton(onPressed: () => context.go('/login'), child: Text('Inicia sesión', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
