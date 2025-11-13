import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/user_info_model.dart';
import 'package:my_route_movil/services/token_service.dart';
import 'package:my_route_movil/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final TokenService _tokenService = TokenService();
  late Future<UserInfo> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _userService.getMe();
  }

  void _logout() async {
    await _tokenService.deleteToken();
    if (mounted) {
      // 'go' limpia la pila de navegación y nos lleva a la pantalla de bienvenida
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: FutureBuilder<UserInfo>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el perfil: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos del usuario.'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  // Placeholder para una imagen de perfil
                  child: Icon(Icons.person, size: 60),
                ),
                const SizedBox(height: 16),
                Text(user.nombre, style: Theme.of(context).textTheme.headlineMedium),
                Text(user.email, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 32),
                const Divider(),
                _buildProfileInfoRow(Icons.badge_outlined, 'Cédula', user.cedula),
                _buildProfileInfoRow(Icons.person_pin_outlined, 'Username', user.username),
                _buildProfileInfoRow(Icons.phone_android_outlined, 'Teléfono', user.telefono),
                _buildProfileInfoRow(Icons.calendar_today_outlined, 'Nacimiento', user.fechaNacimiento.toIso8601String().split('T').first),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                  title: const Text('Mis Rutas Favoritas', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/favorites');
                  },
                ),
                const Divider(),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
