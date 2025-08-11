/// Constantes de la aplicación
/// 
/// Este archivo contiene todas las constantes utilizadas en la aplicación,
/// incluyendo colores, espaciados, tamaños de fuente y configuraciones.
library;

import 'package:flutter/material.dart';

/// Clase que contiene todas las constantes de la aplicación
class AppConstants {
  // Constructor privado para evitar instanciación
  AppConstants._();

  /// Nombre de la aplicación
  static const String appName = 'Flutter Ejemplo App';

  /// Versión de la aplicación
  static const String appVersion = '1.0.0';

  /// Espaciados estándar de la aplicación
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  /// Radios de bordes
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  /// Alturas estándar
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double cardHeight = 120.0;

  /// Duración de animaciones
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
}

/// Rutas de navegación de la aplicación
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String productList = '/products';
  static const String productCatalog = '/catalog';
  static const String productDetail = '/product-detail';
}

/// Mensajes y textos de la aplicación
class AppStrings {
  AppStrings._();

  // Pantalla de Login
  static const String loginTitle = 'Iniciar Sesión';
  static const String emailLabel = 'Correo Electrónico';
  static const String passwordLabel = 'Contraseña';
  static const String loginButton = 'Ingresar';
  static const String emailHint = 'ejemplo@correo.com';
  static const String passwordHint = 'Tu contraseña';

  // Pantalla Principal
  static const String homeTitle = 'Dashboard';
  static const String welcomeMessage = 'Bienvenido a la aplicación';
  static const String productListTitle = 'Lista de Productos';
  static const String catalogTitle = 'Catálogo';

  // Pantalla de Productos
  static const String productsTitle = 'Productos';
  static const String catalogDescription = 'Explora nuestro catálogo de productos';
  static const String noProductsMessage = 'No hay productos disponibles';

  // Pantalla de Detalles
  static const String productDetailsTitle = 'Detalles del Producto';
  static const String addToCartButton = 'Agregar al Carrito';
  static const String backButton = 'Regresar';

  // Navegación
  static const String homeTab = 'Inicio';
  static const String productsTab = 'Productos';
  static const String catalogTab = 'Catálogo';
  static const String profileTab = 'Perfil';

  // Mensajes de error
  static const String errorEmailRequired = 'El correo es requerido';
  static const String errorPasswordRequired = 'La contraseña es requerida';
  static const String errorInvalidEmail = 'Correo electrónico inválido';
}