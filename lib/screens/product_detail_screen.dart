/// Pantalla de detalles del producto
/// 
/// Esta pantalla muestra información detallada de un producto específico
/// con imágenes, descripción, precio y opciones de compra.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/product.dart';
import '../widgets/loading_button.dart';

/// Pantalla que muestra los detalles completos de un producto
class ProductDetailScreen extends StatefulWidget {
  /// Producto a mostrar
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  /// Cantidad seleccionada
  int _quantity = 1;
  
  /// Estado de carga del botón
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen del producto
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.product.imageUrl),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {
                        // Manejar error de imagen
                      },
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareProduct,
                tooltip: 'Compartir',
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: _toggleFavorite,
                tooltip: 'Agregar a favoritos',
              ),
            ],
          ),

          // Contenido del producto
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Información básica
                _buildBasicInfo(),
                const SizedBox(height: AppConstants.paddingLarge),

                // Descripción
                _buildDescription(),
                const SizedBox(height: AppConstants.paddingLarge),

                // Especificaciones
                _buildSpecifications(),
                const SizedBox(height: AppConstants.paddingLarge),

                // Reseñas
                _buildReviews(),
                const SizedBox(height: AppConstants.paddingLarge),

                // Productos relacionados (placeholder)
                _buildRelatedProducts(),
                const SizedBox(height: 100), // Espacio para el bottom bar
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// Construye la información básica del producto
  Widget _buildBasicInfo() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categoría
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Text(
            widget.product.category,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),

        // Nombre del producto
        Text(
          widget.product.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),

        // Precio y calificación
        Row(
          children: [
            Text(
              widget.product.formattedPrice,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const Spacer(),
            if (widget.product.rating > 0) ...[
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                widget.product.formattedRating,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' (${widget.product.reviewCount})',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),

        // Estado de disponibilidad
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          children: [
            Icon(
              widget.product.isAvailable
                  ? Icons.check_circle
                  : Icons.cancel,
              color: widget.product.isAvailable
                  ? Colors.green
                  : Colors.red,
              size: 20,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text(
              widget.product.isAvailable
                  ? 'Disponible'
                  : 'Agotado',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: widget.product.isAvailable
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de descripción
  Widget _buildDescription() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Text(
          widget.product.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// Construye la sección de especificaciones
  Widget _buildSpecifications() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Especificaciones simuladas basadas en el producto
    final specs = _getProductSpecifications();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Especificaciones',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Column(
            children: specs.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        entry.key,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Construye la sección de reseñas
  Widget _buildReviews() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reseñas',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // Navegar a todas las reseñas
              },
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        if (widget.product.reviewCount > 0) ...[
          // Resumen de calificaciones
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.product.formattedRating,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.product.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    Text(
                      '${widget.product.reviewCount} reseñas',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppConstants.paddingLarge),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final stars = 5 - index;
                      final percentage = (widget.product.rating / 5) * 100;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text('$stars'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: stars <= widget.product.rating ? 0.7 : 0.1,
                                backgroundColor: colorScheme.outline.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation(Colors.amber),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Center(
              child: Text(
                'Sé el primero en reseñar este producto',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Construye la sección de productos relacionados
  Widget _buildRelatedProducts() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Productos relacionados',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Center(
            child: Text(
              'Productos relacionados próximamente',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye la barra inferior con controles de compra
  Widget _buildBottomBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Selector de cantidad
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? _decreaseQuantity : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                    ),
                    child: Text(
                      _quantity.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),

            // Botón de agregar al carrito
            Expanded(
              child: LoadingButton(
                onPressed: widget.product.isAvailable ? _addToCart : null,
                isLoading: _isAddingToCart,
                text: widget.product.isAvailable
                    ? AppStrings.addToCartButton
                    : 'Producto Agotado',
                icon: Icons.shopping_cart_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Obtiene especificaciones del producto basadas en su categoría
  Map<String, String> _getProductSpecifications() {
    final category = widget.product.category.toLowerCase();
    
    if (category.contains('smartphone') || category.contains('electrónicos')) {
      return {
        'Pantalla': '6.8" AMOLED',
        'Procesador': 'Snapdragon 8 Gen 3',
        'RAM': '12GB',
        'Almacenamiento': '256GB',
        'Cámara': '108MP + 12MP + 12MP',
        'Batería': '5000mAh',
        'OS': 'Android 14',
      };
    } else if (category.contains('laptop') || category.contains('computadoras')) {
      return {
        'Procesador': 'Intel i7-13700H',
        'GPU': 'RTX 4070 8GB',
        'RAM': '32GB DDR5',
        'Almacenamiento': '1TB SSD NVMe',
        'Pantalla': '15.6" 144Hz',
        'Conectividad': 'WiFi 6E, Bluetooth 5.3',
        'Puertos': '3x USB-A, 2x USB-C, HDMI',
      };
    } else {
      return {
        'Marca': widget.product.category,
        'Modelo': widget.product.name,
        'Garantía': '1 año',
        'Color': 'Varios disponibles',
        'Peso': 'Información no disponible',
        'Dimensiones': 'Información no disponible',
      };
    }
  }

  /// Incrementa la cantidad
  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  /// Decrementa la cantidad
  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  /// Agrega el producto al carrito
  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    // Simular agregado al carrito
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isAddingToCart = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} agregado al carrito'),
          action: SnackBarAction(
            label: 'Ver carrito',
            onPressed: () {
              // Navegar al carrito
            },
          ),
        ),
      );
    }
  }

  /// Comparte el producto
  void _shareProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartiendo ${widget.product.name}'),
      ),
    );
  }

  /// Alterna el estado de favorito
  void _toggleFavorite() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} agregado a favoritos'),
      ),
    );
  }
}