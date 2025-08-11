/// Modelo de datos para productos
/// 
/// Este archivo contiene la clase Product que representa un producto
/// en la aplicación, incluyendo sus propiedades y métodos.
library;

/// Clase que representa un producto en la aplicación
class Product {
  /// Identificador único del producto
  final String id;
  
  /// Nombre del producto
  final String name;
  
  /// Descripción detallada del producto
  final String description;
  
  /// Precio del producto
  final double price;
  
  /// URL de la imagen del producto
  final String imageUrl;
  
  /// Categoría a la que pertenece el producto
  final String category;
  
  /// Indica si el producto está disponible
  final bool isAvailable;
  
  /// Calificación del producto (0-5)
  final double rating;
  
  /// Número de reseñas del producto
  final int reviewCount;

  /// Constructor de la clase Product
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  /// Crea una instancia de Product desde un Map (útil para JSON)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      isAvailable: map['isAvailable'] as bool? ?? true,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
    );
  }

  /// Convierte la instancia de Product a un Map (útil para JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  /// Retorna el precio formateado como texto
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Retorna la calificación formateada
  String get formattedRating => rating.toStringAsFixed(1);

  /// Crea una copia del producto con algunos valores modificados
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category)';
  }
}