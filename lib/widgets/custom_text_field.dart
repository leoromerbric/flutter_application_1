/// Campo de texto personalizado
/// 
/// Widget reutilizable para campos de entrada de texto con
/// validación y estilo consistente con Material 3.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Campo de texto personalizado con validación y estilo Material 3
class CustomTextField extends StatefulWidget {
  /// Controlador del campo de texto
  final TextEditingController controller;
  
  /// Etiqueta del campo
  final String labelText;
  
  /// Texto de ayuda
  final String? hintText;
  
  /// Tipo de teclado
  final TextInputType keyboardType;
  
  /// Icono a mostrar al inicio del campo
  final IconData? prefixIcon;
  
  /// Icono a mostrar al final del campo
  final IconData? suffixIcon;
  
  /// Función de validación
  final String? Function(String?)? validator;
  
  /// Indica si es un campo de contraseña
  final bool isPassword;
  
  /// Indica si el campo está habilitado
  final bool enabled;
  
  /// Número máximo de líneas
  final int maxLines;
  
  /// Callback cuando se presiona el icono sufijo
  final VoidCallback? onSuffixPressed;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isPassword = false,
    this.enabled = true,
    this.maxLines = 1,
    this.onSuffixPressed,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  /// Controla la visibilidad de la contraseña
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscureText : false,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.enabled 
                    ? colorScheme.onSurfaceVariant 
                    : colorScheme.outline,
              )
            : null,
        suffixIcon: _buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        filled: true,
        fillColor: widget.enabled 
            ? colorScheme.surface 
            : colorScheme.surface.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: widget.enabled 
            ? colorScheme.onSurface 
            : colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  /// Construye el icono del sufijo basado en el tipo de campo
  Widget? _buildSuffixIcon() {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: widget.enabled 
              ? colorScheme.onSurfaceVariant 
              : colorScheme.outline,
        ),
        onPressed: widget.enabled ? () {
          setState(() {
            _obscureText = !_obscureText;
          });
        } : null,
      );
    }
    
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: widget.enabled 
              ? colorScheme.onSurfaceVariant 
              : colorScheme.outline,
        ),
        onPressed: widget.enabled ? widget.onSuffixPressed : null,
      );
    }
    
    return null;
  }
}