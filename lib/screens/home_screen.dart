/// Pantalla principal del dashboard
/// 
/// Esta pantalla muestra el dashboard principal de la aplicación
/// con acceso rápido a las diferentes secciones y productos destacados.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';

/// Pantalla principal del dashboard de la aplicación
class HomeScreen extends StatefulWidget {
  /// Callback para navegar a la lista de productos
  final VoidCallback? onNavigateToProducts;
  
  /// Callback para navegar al catálogo
  final VoidCallback? onNavigateToCatalog;
  
  /// Callback para navegar a detalles de producto
  final Function(Product)? onNavigateToProductDetail;

  const HomeScreen({
    super.key,
    this.onNavigateToProducts,
    this.onNavigateToCatalog,
    this.onNavigateToProductDetail,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Servicio de productos
  final ProductService _productService = ProductService();
  
  /// Servicio de autenticación
  final AuthService _authService = AuthService();
  
  /// Lista de productos destacados
  List<Product> _featuredProducts = [];
  
  /// Estado de carga
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeaturedProducts();
  }

  /// Carga los productos destacados
  Future<void> _loadFeaturedProducts() async {
    try {
      final products = await _productService.getFeaturedProducts(limit: 4);
      if (mounted) {
        setState(() {
          _featuredProducts = products;
          _isLoading = false;
        });
      }
    } catch (e) {
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
    final user = _authService.currentUser;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadFeaturedProducts,
        child: CustomScrollView(
          slivers: [
            // App Bar expandible
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  AppStrings.homeTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.secondaryContainer,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      user?.initials ?? 'U',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () => _showUserMenu(context),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
              ],
            ),

            // Contenido principal
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Saludo al usuario
                  _buildWelcomeSection(user?.name ?? 'Usuario'),
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Tarjetas de navegación rápida
                  _buildQuickAccessCards(),
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Productos destacados
                  SectionHeader(
                    title: 'Productos Destacados',
                    subtitle: 'Los mejor calificados',
                    onViewAll: widget.onNavigateToProducts,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),

                  // Lista de productos destacados
                  if (_isLoading)
                    _buildLoadingGrid()
                  else if (_featuredProducts.isEmpty)
                    _buildEmptyState()
                  else
                    _buildProductsGrid(),

                  const SizedBox(height: AppConstants.paddingLarge),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la sección de bienvenida
  Widget _buildWelcomeSection(String userName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Hola, $userName!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            AppStrings.welcomeMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye las tarjetas de acceso rápido
  Widget _buildQuickAccessCards() {
    return Row(
      children: [
        Expanded(
          child: _QuickAccessCard(
            icon: Icons.list_rounded,
            title: AppStrings.productListTitle,
            subtitle: 'Ver todos',
            onTap: widget.onNavigateToProducts,
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: _QuickAccessCard(
            icon: Icons.grid_view_rounded,
            title: AppStrings.catalogTitle,
            subtitle: 'Explorar',
            onTap: widget.onNavigateToCatalog,
          ),
        ),
      ],
    );
  }

  /// Construye la grilla de productos
  Widget _buildProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
      ),
      itemCount: _featuredProducts.length,
      itemBuilder: (context, index) {
        final product = _featuredProducts[index];
        return ProductCard(
          product: product,
          onTap: () => widget.onNavigateToProductDetail?.call(product),
        );
      },
    );
  }

  /// Construye el estado de carga
  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const ProductCard.loading();
      },
    );
  }

  /// Construye el estado vacío
  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'No hay productos disponibles',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el menú del usuario
  void _showUserMenu(BuildContext context) {
    final user = _authService.currentUser;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user?.initials ?? 'U',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(user?.name ?? 'Usuario'),
              subtitle: Text(user?.email ?? ''),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                _authService.logout();
                // Aquí se manejaría la navegación al login
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para las tarjetas de acceso rápido
class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}