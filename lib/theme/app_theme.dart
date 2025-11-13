import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta de Colores
  static const Color primary = Color(0xFF2E7D32); // Verde oscuro (naturaleza)
  static const Color secondary = Color(0xFF1976D2); // Azul (viaje)
  static const Color accent = Color(0xFFFBC02D);   // Arena/Dorado (tesoro)
  static const Color background = Color(0xFFF5F5F5); // Fondo limpio
  static const Color onPrimary = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: background,

    // Esquema de colores
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      background: background,
      onPrimary: onPrimary,
      onSecondary: Colors.white,
      onBackground: Colors.black87,
      error: Colors.redAccent,
    ),

    // Tema de Texto con Poppins
    textTheme: GoogleFonts.poppinsTextTheme(),

    // Tema para AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: onPrimary,
      elevation: 4,
      titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: onPrimary),
    ),

    // Tema para Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Botones redondeados
        ),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Tema para Cards
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Cards redondeadas
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    ),
    
    // Tema para Inputs de texto
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: primary, width: 2.0),
      ),
      labelStyle: TextStyle(
        color: Colors.grey[700],
      ),
    ),
  );
}
