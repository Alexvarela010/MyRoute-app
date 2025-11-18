import 'package:go_router/go_router.dart';
import 'package:my_route_movil/models/punto_visita_model.dart';
import 'package:my_route_movil/models/route_detail_model.dart';
import 'package:my_route_movil/screens/booking/booking_screen.dart';
import 'package:my_route_movil/screens/booking_success/booking_success_screen.dart';
import 'package:my_route_movil/screens/bookings/bookings_screen.dart';
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
  initialLocation: '/', 
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/route/:id',
      builder: (context, state) {
        final routeId = int.parse(state.pathParameters['id']!);
        return RouteDetailScreen(routeId: routeId);
      },
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/bookings', builder: (context, state) => const BookingsScreen()),
    GoRoute(
      path: '/booking',
      builder: (context, state) {
        final routeDetail = state.extra as RouteDetail;
        return BookingScreen(routeDetail: routeDetail);
      },
    ),
    GoRoute(path: '/booking-success', builder: (context, state) => const BookingSuccessScreen()),
    GoRoute(path: '/create-route', builder: (context, state) => const CreateRouteScreen()),
    GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen()),
    // --- CORRECCIÓN FINAL ---
    GoRoute(
      path: '/map',
      builder: (context, state) {
        // Se permite que la lista de puntos sea nula.
        final puntos = state.extra as List<PuntoVisita>?; 
        return MapScreen(puntosDeVisita: puntos); // Se pasa el valor, que puede ser null.
      },
    ),
  ],
);
