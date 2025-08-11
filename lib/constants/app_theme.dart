/// Configuración de temas para la aplicación
/// 
/// Este archivo contiene la configuración del tema Material 3 para la aplicación,
/// incluyendo colores, tipografía y otros aspectos visuales.
library;

import 'package:flutter/material.dart';

/// Clase que maneja la configuración de temas de la aplicación
class AppTheme {
  // Constructor privado para evitar instanciación
  AppTheme._();

  /// Esquema de colores principal para el tema claro
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6750A4),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005D),
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1D192B),
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    inverseOnSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFFD0BCFF),
    surfaceTint: Color(0xFF6750A4),
  );

  /// Esquema de colores para el tema oscuro
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378B),
    onPrimaryContainer: Color(0xFFEADDFF),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E1E5),
    inverseOnSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF6750A4),
    surfaceTint: Color(0xFFD0BCFF),
  );

  /// Tema claro de la aplicación con Material 3
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1C1B1F),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  /// Tema oscuro de la aplicación con Material 3
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFE6E1E5),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}