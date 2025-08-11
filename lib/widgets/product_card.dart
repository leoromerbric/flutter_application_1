/// Tarjeta de producto
/// 
/// Widget reutilizable para mostrar información de productos
/// en listas y grillas con Material 3 design.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/product.dart';

/// Tarjeta que muestra información de un producto
class ProductCard extends StatelessWidget {
  /// Producto a mostrar
  final Product? product;
  
  /// Callback cuando se toca la tarjeta
  final VoidCallback? onTap;
  
  /// Indica si es una tarjeta en modo loading
  final bool isLoading;
  
  /// Ancho de la tarjeta (opcional)
  final double? width;

  /// Constructor para tarjeta normal
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.width,
  }) : isLoading = false;

  /// Constructor para tarjeta en estado de carga
  const ProductCard.loading({
    super.key,
    this.width,
  }) : product = null,
       onTap = null,
       isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingCard(context);
    }

    if (product == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: width,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              Expanded(
                child: _buildProductInfo(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la imagen del producto
  Widget _buildProductImage() {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          image: product?.imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(product!.imageUrl),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    // En caso de error, se mostrará el color de fondo
                  },
                )
              : null,
        ),
        child: Stack(
          children: [
            // Overlay con gradiente sutil
            if (product?.imageUrl != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
            
            // Badge de disponibilidad
            if (product?.isAvailable == false)
              Positioned(
                top: AppConstants.paddingSmall,
                right: AppConstants.paddingSmall,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: const Text(
                    'Agotado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Badge de calificación
            if (product != null && product!.rating > 0)
              Positioned(
                top: AppConstants.paddingSmall,
                left: AppConstants.paddingSmall,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product!.formattedRating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Construye la información del producto
  Widget _buildProductInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del producto
          Text(
            product!.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          
          // Categoría
          Text(
            product!.category,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          
          // Precio y reviews
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Precio
              Text(
                product!.formattedPrice,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              
              // Número de reviews
              if (product!.reviewCount > 0)
                Text(
                  '(${product!.reviewCount})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la tarjeta en estado de carga
  Widget _buildLoadingCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: width,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen placeholder
            AspectRatio(
              aspectRatio: 1.2,
              child: Container(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            
            // Información placeholder
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título placeholder
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Subtítulo placeholder
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    
                    // Precio placeholder
                    Container(
                      height: 14,
                      width: 60,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Variante horizontal de la tarjeta de producto
class ProductCardHorizontal extends StatelessWidget {
  /// Producto a mostrar
  final Product product;
  
  /// Callback cuando se toca la tarjeta
  final VoidCallback? onTap;

  const ProductCardHorizontal({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Imagen del producto
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      // Manejar error de imagen
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              
              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          product.formattedPrice,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        if (product.rating > 0) ...[
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.formattedRating,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}