/// Modelo de datos para usuarios
/// 
/// Este archivo contiene la clase User que representa un usuario
/// en la aplicación, incluyendo sus propiedades y métodos.
library;

/// Clase que representa un usuario en la aplicación
class User {
  /// Identificador único del usuario
  final String id;
  
  /// Nombre completo del usuario
  final String name;
  
  /// Correo electrónico del usuario
  final String email;
  
  /// URL de la imagen de perfil del usuario
  final String? profileImageUrl;
  
  /// Fecha de registro del usuario
  final DateTime? createdAt;

  /// Constructor de la clase User
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.createdAt,
  });

  /// Crea una instancia de User desde un Map (útil para JSON)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      profileImageUrl: map['profileImageUrl']?.toString(),
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'].toString())
          : null,
    );
  }

  /// Convierte la instancia de User a un Map (útil para JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Retorna las iniciales del nombre del usuario
  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return '';
  }

  /// Crea una copia del usuario con algunos valores modificados
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}