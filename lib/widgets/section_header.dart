/// Widget de encabezado de sección
/// 
/// Componente reutilizable para mostrar títulos de secciones
/// con subtítulos opcionales y acción de "Ver todo".
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Widget que muestra un encabezado de sección con título, subtítulo y acción opcional
class SectionHeader extends StatelessWidget {
  /// Título principal de la sección
  final String title;
  
  /// Subtítulo o descripción opcional
  final String? subtitle;
  
  /// Texto del botón de acción (por defecto "Ver todo")
  final String? actionText;
  
  /// Callback cuando se presiona la acción
  final VoidCallback? onViewAll;
  
  /// Icono a mostrar junto al título (opcional)
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onViewAll,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icono opcional
        if (icon != null) ...[
          Icon(
            icon,
            size: 24,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppConstants.paddingSmall),
        ],
        
        // Título y subtítulo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Botón de acción
        if (onViewAll != null) ...[
          const SizedBox(width: AppConstants.paddingMedium),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionText ?? 'Ver todo',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Variante compacta del encabezado de sección
class CompactSectionHeader extends StatelessWidget {
  /// Título de la sección
  final String title;
  
  /// Callback cuando se presiona la acción
  final VoidCallback? onViewAll;
  
  /// Texto del botón de acción
  final String? actionText;

  const CompactSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
              ),
            ),
            child: Text(
              actionText ?? 'Ver todo',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}