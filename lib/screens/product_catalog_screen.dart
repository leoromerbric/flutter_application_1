/// Pantalla de catálogo de productos
///
/// Esta pantalla muestra los productos organizados por categorías
/// con una vista más visual y enfocada en la exploración.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';

/// Pantalla que muestra el catálogo de productos organizados por categorías
class ProductCatalogScreen extends StatefulWidget {
  /// Callback para navegar a detalles de producto
  final Function(Product)? onNavigateToProductDetail;

  const ProductCatalogScreen({super.key, this.onNavigateToProductDetail});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen>
    with TickerProviderStateMixin {
  /// Servicio de productos
  final ProductService _productService = ProductService();

  /// Controlador de tabs
  late TabController _tabController;

  /// Mapa de productos por categoría
  Map<String, List<Product>> _productsByCategory = {};

  /// Lista de categorías
  List<String> _categories = [];

  /// Estado de carga
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Carga productos y los organiza por categorías
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allProducts = await _productService.getAllProducts();
      final categories = _productService.getCategories();

      // Organizar productos por categoría
      final productsByCategory = <String, List<Product>>{};
      for (final category in categories) {
        productsByCategory[category] = allProducts
            .where((product) => product.category == category)
            .toList();
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _productsByCategory = productsByCategory;
          _isLoading = false;
        });

        // Inicializar el TabController después de tener las categorías
        _tabController = TabController(length: _categories.length, vsync: this);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar el catálogo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.catalogTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar principal
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  AppStrings.catalogTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
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
                        colorScheme.tertiaryContainer,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 120,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tabs de categorías
            if (_categories.isNotEmpty)
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  tabBar: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.primary,
                    tabs: _categories
                        .map(
                          (category) => Tab(
                            text: category,
                            icon: _getCategoryIcon(category),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ];
        },
        body: _categories.isEmpty
            ? _buildEmptyState()
            : TabBarView(
                controller: _tabController,
                children: _categories
                    .map((category) => _buildCategoryView(category))
                    .toList(),
              ),
      ),
    );
  }

  /// Construye la vista de una categoría
  Widget _buildCategoryView(String category) {
    final products = _productsByCategory[category] ?? [];

    if (products.isEmpty) {
      return _buildEmptyCategoryState(category);
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: CustomScrollView(
        slivers: [
          // Información de la categoría
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _getCategoryIcon(category),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Text(
                          category,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      '${products.length} productos disponibles',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Grilla de productos
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: AppConstants.paddingMedium,
                mainAxisSpacing: AppConstants.paddingMedium,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => widget.onNavigateToProductDetail?.call(product),
                );
              }, childCount: products.length),
            ),
          ),

          // Espaciado final
          const SliverPadding(
            padding: EdgeInsets.only(bottom: AppConstants.paddingLarge),
          ),
        ],
      ),
    );
  }

  /// Construye el estado vacío para una categoría
  Widget _buildEmptyCategoryState(String category) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getCategoryIcon(category, size: 64),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'No hay productos en $category',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Esta categoría estará disponible pronto',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el estado vacío general
  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Catálogo no disponible',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'No hay productos para mostrar',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Obtiene el icono para una categoría
  Widget _getCategoryIcon(String category, {double size = 24}) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData iconData;
    switch (category.toLowerCase()) {
      case 'electrónicos':
      case 'electronicos':
        iconData = Icons.phone_android;
        break;
      case 'computadoras':
        iconData = Icons.computer;
        break;
      case 'audio':
        iconData = Icons.headphones;
        break;
      case 'wearables':
        iconData = Icons.watch;
        break;
      case 'tablets':
        iconData = Icons.tablet;
        break;
      case 'fotografía':
      case 'fotografia':
        iconData = Icons.camera_alt;
        break;
      case 'gaming':
        iconData = Icons.sports_esports;
        break;
      case 'monitores':
        iconData = Icons.desktop_mac;
        break;
      default:
        iconData = Icons.category;
    }

    return Icon(iconData, size: size, color: colorScheme.primary);
  }
}

/// Delegado para mantener la TabBar fija
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
