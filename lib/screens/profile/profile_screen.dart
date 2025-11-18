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
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: FutureBuilder<UserInfo>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('No se pudieron cargar los datos.'));
          }

          final user = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Mi Perfil', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                ),
              ),

              // --- TARJETA DE USUARIO ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildUserCard(user, textTheme, colorScheme),
                ),
              ),

              // --- GRID DE ESTADÍSTICAS ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildStatsGrid(textTheme, colorScheme),
                ),
              ),

              // --- LISTA DE OPCIONES ---
              SliverList(delegate: SliverChildListDelegate([
                _buildOptionItem(Icons.calendar_today_outlined, 'Mis reservas', () => context.push('/bookings')),
                _buildOptionItem(Icons.payment_outlined, 'Métodos de pago', () {}),
                _buildOptionItem(Icons.notifications_none_outlined, 'Notificaciones', () {}),
                _buildOptionItem(Icons.settings_outlined, 'Configuración', () {}),
                const SizedBox(height: 20),
                _buildOptionItem(Icons.logout, 'Cerrar sesión', _logout, color: colorScheme.error),
              ]))
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Perfil es el cuarto item
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/map');
          if (index == 2) context.go('/favorites');
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // Tarjeta de usuario con gradiente
  Widget _buildUserCard(UserInfo user, TextTheme textTheme, ColorScheme colorScheme) {
    final initials = user.nombre.isNotEmpty ? user.nombre.split(' ').map((e) => e[0]).take(2).join() : 'U';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft, end: Alignment.bottomRight, 
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Text(initials, style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary))),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.nombre, style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(user.email, style: textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ],
      ),
    );
  }

  // Grid de estadísticas
  Widget _buildStatsGrid(TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Rutas', '12', textTheme, colorScheme.primary),
        _buildStatItem('Completadas', '8', textTheme, colorScheme.secondary),
        _buildStatItem('Rating', '4.8', textTheme, colorScheme.tertiary),
      ],
    );
  }

  Column _buildStatItem(String label, String value, TextTheme textTheme, Color color) {
    return Column(
      children: [
        Text(value, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
        Text(label, style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  // Item de la lista de opciones
  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).colorScheme.onSurface),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}
