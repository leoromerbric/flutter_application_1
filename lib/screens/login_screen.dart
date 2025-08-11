/// Pantalla de inicio de sesión
/// 
/// Esta pantalla permite a los usuarios iniciar sesión en la aplicación
/// con validación de formularios y manejo de errores.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_button.dart';

/// Pantalla de login de la aplicación
class LoginScreen extends StatefulWidget {
  /// Callback que se ejecuta cuando el login es exitoso
  final VoidCallback? onLoginSuccess;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  /// Clave del formulario para validaciones
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  /// Servicio de autenticación
  final AuthService _authService = AuthService();
  
  /// Estado de carga del botón de login
  bool _isLoading = false;
  
  /// Mensaje de error a mostrar
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Maneja el proceso de login
  Future<void> _handleLogin() async {
    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Intentar hacer login
      final user = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (user != null) {
          // Login exitoso
          widget.onLoginSuccess?.call();
        } else {
          // Login fallido
          setState(() {
            _errorMessage = 'Credenciales incorrectas. Intenta nuevamente.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error de conexión. Verifica tu internet.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo y título
                Icon(
                  Icons.shopping_bag_rounded,
                  size: 80,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                
                Text(
                  AppStrings.loginTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingXLarge),

                // Campo de email
                CustomTextField(
                  controller: _emailController,
                  labelText: AppStrings.emailLabel,
                  hintText: AppStrings.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: _authService.validateEmail,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppConstants.paddingMedium),

                // Campo de contraseña
                CustomTextField(
                  controller: _passwordController,
                  labelText: AppStrings.passwordLabel,
                  hintText: AppStrings.passwordHint,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: _authService.validatePassword,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppConstants.paddingLarge),

                // Mensaje de error
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                ],

                // Botón de login
                LoadingButton(
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  text: AppStrings.loginButton,
                ),
                const SizedBox(height: AppConstants.paddingLarge),

                // Texto informativo
                Text(
                  'Usa cualquier email válido y contraseña para continuar',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}