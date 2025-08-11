/// Botón con estado de carga
/// 
/// Widget reutilizable para botones que necesitan mostrar
/// un indicador de carga durante operaciones asíncronas.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Botón elevado con estado de carga integrado
class LoadingButton extends StatelessWidget {
  /// Función a ejecutar cuando se presiona el botón
  final VoidCallback? onPressed;
  
  /// Texto a mostrar en el botón
  final String text;
  
  /// Indica si el botón está en estado de carga
  final bool isLoading;
  
  /// Icono a mostrar en el botón (opcional)
  final IconData? icon;
  
  /// Color del botón (usa el color primario del tema si no se especifica)
  final Color? backgroundColor;
  
  /// Color del texto (usa el color onPrimary del tema si no se especifica)
  final Color? textColor;
  
  /// Ancho del botón (toma todo el ancho disponible si no se especifica)
  final double? width;
  
  /// Alto del botón
  final double height;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = AppConstants.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: textColor ?? colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.surfaceVariant,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          elevation: isLoading ? 0 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
        child: AnimatedSwitcher(
          duration: AppConstants.shortAnimationDuration,
          child: isLoading
              ? _buildLoadingIndicator(colorScheme)
              : _buildButtonContent(theme),
        ),
      ),
    );
  }

  /// Construye el indicador de carga
  Widget _buildLoadingIndicator(ColorScheme colorScheme) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          textColor ?? colorScheme.onPrimary,
        ),
      ),
    );
  }

  /// Construye el contenido normal del botón
  Widget _buildButtonContent(ThemeData theme) {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Variante del botón con estilo de contorno
class LoadingOutlinedButton extends StatelessWidget {
  /// Función a ejecutar cuando se presiona el botón
  final VoidCallback? onPressed;
  
  /// Texto a mostrar en el botón
  final String text;
  
  /// Indica si el botón está en estado de carga
  final bool isLoading;
  
  /// Icono a mostrar en el botón (opcional)
  final IconData? icon;
  
  /// Ancho del botón
  final double? width;
  
  /// Alto del botón
  final double height;

  const LoadingOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = AppConstants.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: (isLoading || onPressed == null) ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
        child: AnimatedSwitcher(
          duration: AppConstants.shortAnimationDuration,
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                )
              : _buildButtonContent(theme, colorScheme),
        ),
      ),
    );
  }

  /// Construye el contenido normal del botón outlined
  Widget _buildButtonContent(ThemeData theme, ColorScheme colorScheme) {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
      ),
    );
  }
}