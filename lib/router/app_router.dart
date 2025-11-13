import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/punto_visita_model.dart';
import 'package:my_route_movil/screens/create_route/create_route_screen.dart';
import 'package:my_route_movil/screens/favorites/favorites_screen.dart';
import 'package:my_route_movil/screens/home/home_screen.dart';
import 'package:my_route_movil/screens/map/map_screen.dart';
import 'package:my_route_movil/screens/profile/profile_screen.dart';
import 'package:my_route_movil/screens/route_detail/route_detail_screen.dart';
import 'package:my_route_movil/screens/welcome/welcome_screen.dart';
import 'package:my_route_movil/screens/login/login_screen.dart';
import 'package:my_route_movil/screens/register/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/', // La ruta inicial es la pantalla de bienvenida
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/route/:id',
      builder: (context, state) {
        final routeId = int.parse(state.pathParameters['id']!);
        return RouteDetailScreen(routeId: routeId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/create-route',
      builder: (context, state) => const CreateRouteScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) {
        // Recibir la lista de puntos como un objeto extra
        final puntos = state.extra as List<PuntoVisita>;
        return MapScreen(puntosDeVisita: puntos);
      },
    ),
  ],
);
