/// Servicio de autenticación
/// 
/// Este archivo contiene la lógica de autenticación de usuarios,
/// incluyendo login, logout y manejo de estado de sesión.
library;

import '../models/user.dart';

/// Servicio que maneja la autenticación de usuarios
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Usuario actualmente logueado
  User? _currentUser;

  /// Getter para obtener el usuario actual
  User? get currentUser => _currentUser;

  /// Verifica si hay un usuario logueado
  bool get isLoggedIn => _currentUser != null;

  /// Simula el proceso de login
  /// 
  /// En una aplicación real, esto haría una llamada a una API
  /// para validar las credenciales del usuario.
  /// 
  /// [email] - Correo electrónico del usuario
  /// [password] - Contraseña del usuario
  /// 
  /// Retorna [User] si el login es exitoso, null si falla
  Future<User?> login(String email, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 2));

    // Validación básica (en una app real sería más robusta)
    if (_isValidEmail(email) && password.isNotEmpty) {
      // Simular usuario exitoso
      _currentUser = User(
        id: '1',
        name: _getNameFromEmail(email),
        email: email,
        profileImageUrl: null,
        createdAt: DateTime.now(),
      );
      return _currentUser;
    }

    // Login fallido
    return null;
  }

  /// Cierra la sesión del usuario actual
  Future<void> logout() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  /// Valida si un email tiene formato correcto
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Extrae un nombre a partir del email
  String _getNameFromEmail(String email) {
    final username = email.split('@')[0];
    // Capitalizar primera letra
    return username[0].toUpperCase() + username.substring(1);
  }

  /// Valida las credenciales de forma síncrona
  /// 
  /// Útil para validaciones en tiempo real en formularios
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'El correo es requerido';
    }
    if (!_isValidEmail(email)) {
      return 'Formato de correo inválido';
    }
    return null;
  }

  /// Valida la contraseña de forma síncrona
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }
}