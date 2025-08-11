/// Servicio de productos
/// 
/// Este archivo contiene la lógica para manejar productos,
/// incluyendo obtener listas, filtrar y buscar productos.
library;

import '../models/product.dart';

/// Servicio que maneja la gestión de productos
class ProductService {
  // Singleton pattern
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  /// Lista simulada de productos
  static final List<Product> _products = [
    Product(
      id: '1',
      name: 'Smartphone Galaxy S24',
      description: 'Último modelo de smartphone con cámara de 108MP, pantalla AMOLED de 6.8" y procesador Snapdragon 8 Gen 3. Incluye carga rápida de 45W y resistencia al agua IP68.',
      price: 899.99,
      imageUrl: 'https://via.placeholder.com/300x300/6750A4/FFFFFF?text=Galaxy+S24',
      category: 'Electrónicos',
      rating: 4.5,
      reviewCount: 1250,
    ),
    Product(
      id: '2',
      name: 'Laptop Gaming Pro',
      description: 'Laptop gaming de alto rendimiento con RTX 4070, Intel i7-13700H, 32GB RAM DDR5 y SSD de 1TB. Pantalla de 15.6" con tasa de refresco de 144Hz.',
      price: 1599.99,
      imageUrl: 'https://via.placeholder.com/300x300/7D5260/FFFFFF?text=Gaming+Laptop',
      category: 'Computadoras',
      rating: 4.8,
      reviewCount: 890,
    ),
    Product(
      id: '3',
      name: 'Auriculares Bluetooth Premium',
      description: 'Auriculares inalámbricos con cancelación activa de ruido, 30 horas de batería y calidad de audio Hi-Fi. Diseño ergonómico y resistentes al sudor.',
      price: 199.99,
      imageUrl: 'https://via.placeholder.com/300x300/625B71/FFFFFF?text=Auriculares',
      category: 'Audio',
      rating: 4.3,
      reviewCount: 567,
    ),
    Product(
      id: '4',
      name: 'Smartwatch Series 9',
      description: 'Reloj inteligente con monitoreo de salud 24/7, GPS integrado, resistencia al agua hasta 50m y batería de hasta 18 horas.',
      price: 399.99,
      imageUrl: 'https://via.placeholder.com/300x300/49454F/FFFFFF?text=Smartwatch',
      category: 'Wearables',
      rating: 4.6,
      reviewCount: 2134,
    ),
    Product(
      id: '5',
      name: 'Tablet Pro 12.9"',
      description: 'Tablet profesional con chip M2, pantalla Liquid Retina XDR de 12.9", soporte para Apple Pencil y Magic Keyboard. Ideal para creativos y profesionales.',
      price: 1099.99,
      imageUrl: 'https://via.placeholder.com/300x300/381E72/FFFFFF?text=Tablet+Pro',
      category: 'Tablets',
      rating: 4.7,
      reviewCount: 445,
    ),
    Product(
      id: '6',
      name: 'Cámara Mirrorless 4K',
      description: 'Cámara sin espejo con sensor de 24MP, grabación 4K a 60fps, estabilización de imagen en el cuerpo y conectividad WiFi/Bluetooth.',
      price: 1299.99,
      imageUrl: 'https://via.placeholder.com/300x300/4F378B/FFFFFF?text=Cámara+4K',
      category: 'Fotografía',
      rating: 4.4,
      reviewCount: 312,
    ),
    Product(
      id: '7',
      name: 'Console Gaming Next-Gen',
      description: 'Consola de videojuegos de última generación con SSD de alta velocidad, ray tracing y soporte para 4K a 120fps. Incluye control inalámbrico.',
      price: 499.99,
      imageUrl: 'https://via.placeholder.com/300x300/693B48/FFFFFF?text=Console',
      category: 'Gaming',
      rating: 4.9,
      reviewCount: 3456,
    ),
    Product(
      id: '8',
      name: 'Monitor 4K 27" Pro',
      description: 'Monitor profesional 4K IPS de 27" con 99% sRGB, conectividad USB-C, altura ajustable y certificación HDR400 para trabajo creativo.',
      price: 649.99,
      imageUrl: 'https://via.placeholder.com/300x300/332D41/FFFFFF?text=Monitor+4K',
      category: 'Monitores',
      rating: 4.2,
      reviewCount: 789,
    ),
  ];

  /// Obtiene todos los productos disponibles
  /// 
  /// Simula una llamada a API con delay
  Future<List<Product>> getAllProducts() async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_products);
  }

  /// Obtiene productos por categoría
  /// 
  /// [category] - Categoría a filtrar
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _products.where((product) => 
        product.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Busca productos por nombre o descripción
  /// 
  /// [query] - Término de búsqueda
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (query.isEmpty) return [];
    
    final queryLower = query.toLowerCase();
    return _products.where((product) => 
        product.name.toLowerCase().contains(queryLower) ||
        product.description.toLowerCase().contains(queryLower) ||
        product.category.toLowerCase().contains(queryLower)
    ).toList();
  }

  /// Obtiene un producto por su ID
  /// 
  /// [id] - Identificador del producto
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene las categorías disponibles
  List<String> getCategories() {
    return _products.map((product) => product.category).toSet().toList()..sort();
  }

  /// Obtiene productos destacados (con mejor calificación)
  Future<List<Product>> getFeaturedProducts({int limit = 4}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final sortedProducts = List<Product>.from(_products)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    
    return sortedProducts.take(limit).toList();
  }

  /// Obtiene productos por rango de precio
  /// 
  /// [minPrice] - Precio mínimo
  /// [maxPrice] - Precio máximo
  Future<List<Product>> getProductsByPriceRange(double minPrice, double maxPrice) async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    return _products.where((product) => 
        product.price >= minPrice && product.price <= maxPrice).toList();
  }
}