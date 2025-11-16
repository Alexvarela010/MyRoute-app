import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- NUEVA PALETA DE COLORES ---
  static const Color primary = Color(0xFF059669);        // Verde principal
  static const Color secondary = Color(0xFF0EA5E9);      // Azul
  static const Color accent = Color(0xFFD4A574);         // Arena/dorado
  static const Color background = Color(0xFFFAFAF8);     // Fondo claro beige
  static const Color card = Color(0xFFFFFFFF);           // Blanco para tarjetas
  static const Color muted = Color(0xFFF5F3EF);          // Fondo secundario suave
  static const Color mutedForeground = Color(0xFF6B7280);  // Texto secundario gris
  static const Color foreground = Color(0xFF1F2937);     // Texto principal oscuro
  static const Color destructive = Color(0xFFEF4444);    // Rojo para acciones destructivas
  static final Color border = const Color(0xFF000000).withOpacity(0.08); // Borde sutil

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: background,

    // --- ESQUEMA DE COLORES ACTUALIZADO ---
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      background: background,
      surface: card, // Usamos 'card' como superficie principal
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: foreground,
      onSurface: foreground,
      error: destructive,
    ),

    // --- TIPOGRAFÍA ACTUALIZADA ---
    // Usamos Inter como fuente principal para toda la app.
    textTheme: GoogleFonts.interTextTheme(),

    // Tema para AppBar (lo mantendremos simple por ahora)
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0, // Sin sombra para un look minimalista
      titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500, color: foreground),
      iconTheme: const IconThemeData(color: foreground),
    ),

    // Tema para Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        // Usamos esquinas totalmente redondeadas como en el diseño
        shape: const StadiumBorder(), 
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    // Tema para Cards (rounded-2xl se traduce a 1rem o 16px)
    cardTheme: CardThemeData(
      color: card,
      elevation: 1, // Sombra muy sutil (shadow-sm)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), 
        side: BorderSide(color: border), // Borde sutil
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    ),
    
    // Tema para Inputs de texto (h-12 y rounded-xl)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: muted,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // h-12 aprox
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0), // rounded-xl
        borderSide: BorderSide.none, // Sin borde visible como en el diseño
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primary, width: 2.0),
      ),
      hintStyle: TextStyle(
        color: mutedForeground,
      ),
    ),
  );
}
