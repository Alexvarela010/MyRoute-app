import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_route_movil/theme/app_theme.dart';
import 'package:my_route_movil/router/app_router.dart';

void main() async {
  // Asegurarse de que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  // Cargar las variables de entorno
  await dotenv.load(fileName: ".env");

  // --- PASO DE DEPURACIÓN DEFINITIVO ---
  // Imprimir el valor de la variable de entorno para verificar que se cargó correctamente.
  if (kDebugMode) {
    print('==========================================================');
    print('VALOR DE API_BASE_URL CARGADO: ${dotenv.env['API_BASE_URL']}');
    print('==========================================================');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MyRoute',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter, // Usar la configuración del router
    );
  }
}
