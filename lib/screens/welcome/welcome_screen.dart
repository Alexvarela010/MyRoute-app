import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder para un logo
            const Icon(Icons.explore_rounded, size: 120, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'MyRoute',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tu aventura comienza aquí',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // Navegación al login
                 context.push('/login');
              },
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navegación al registro (aún no creada)
                 context.push('/login'); // Temporalmente va a login
              },
              child: const Text(
                '¿No tienes una cuenta? Regístrate',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
