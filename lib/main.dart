/// Aplicación principal Flutter
/// 
/// Punto de entrada de la aplicación con navegación entre múltiples pantallas
/// incluyendo login, dashboard, lista de productos y catálogo.
library;

import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'constants/app_theme.dart';
import 'models/product.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_catalog_screen.dart';
import 'screens/product_detail_screen.dart';
import 'services/auth_service.dart';

/// Función principal de la aplicación
void main() {
  runApp(const FlutterExampleApp());
}

/// Aplicación principal con navegación y temas Material 3
class FlutterExampleApp extends StatelessWidget {
  const FlutterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const AppNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Enum para identificar las diferentes pantallas
enum AppScreen {
  login,
  home,
  productList,
  productCatalog,
  productDetail,
}

/// Widget navegador principal que maneja el estado de autenticación y navegación
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  /// Servicio de autenticación
  final AuthService _authService = AuthService();
  
  /// Pantalla actual
  AppScreen _currentScreen = AppScreen.login;
  
  /// Índice de la página actual en el bottom navigation
  int _currentIndex = 0;
  
  /// Producto seleccionado para mostrar detalles
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    // Verificar si hay usuario logueado
    if (_authService.isLoggedIn) {
      _currentScreen = AppScreen.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AppScreen.login:
        return LoginScreen(
          onLoginSuccess: () {
            setState(() {
              _currentScreen = AppScreen.home;
              _currentIndex = 0;
            });
          },
        );

      case AppScreen.productDetail:
        return Scaffold(
          body: ProductDetailScreen(
            product: _selectedProduct!,
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _currentScreen = _getScreenFromIndex(_currentIndex);
                  _selectedProduct = null;
                });
              },
            ),
          ),
        );

      case AppScreen.home:
      case AppScreen.productList:
      case AppScreen.productCatalog:
        return _buildMainNavigationView();
    }
  }

  /// Construye la vista principal con bottom navigation
  Widget _buildMainNavigationView() {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onNavigateToProducts: () => _navigateToTab(1),
            onNavigateToCatalog: () => _navigateToTab(2),
            onNavigateToProductDetail: _navigateToProductDetail,
          ),
          ProductListScreen(
            onNavigateToProductDetail: _navigateToProductDetail,
          ),
          ProductCatalogScreen(
            onNavigateToProductDetail: _navigateToProductDetail,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _navigateToTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.homeTab,
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: AppStrings.productsTab,
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: AppStrings.catalogTab,
          ),
        ],
      ),
    );
  }

  /// Navega a una tab específica del bottom navigation
  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentScreen = _getScreenFromIndex(index);
    });
  }

  /// Navega a la pantalla de detalles de producto
  void _navigateToProductDetail(Product product) {
    setState(() {
      _selectedProduct = product;
      _currentScreen = AppScreen.productDetail;
    });
  }

  /// Obtiene la pantalla correspondiente al índice
  AppScreen _getScreenFromIndex(int index) {
    switch (index) {
      case 0:
        return AppScreen.home;
      case 1:
        return AppScreen.productList;
      case 2:
        return AppScreen.productCatalog;
      default:
        return AppScreen.home;
    }
  }
}
