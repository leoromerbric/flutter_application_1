/// Pantalla de lista de productos
/// 
/// Esta pantalla muestra una lista de todos los productos
/// con funcionalidades de búsqueda y filtrado.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_text_field.dart';

/// Pantalla que muestra la lista de productos con búsqueda y filtros
class ProductListScreen extends StatefulWidget {
  /// Callback para navegar a detalles de producto
  final Function(Product)? onNavigateToProductDetail;

  const ProductListScreen({
    super.key,
    this.onNavigateToProductDetail,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  /// Servicio de productos
  final ProductService _productService = ProductService();
  
  /// Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  
  /// Lista de todos los productos
  List<Product> _allProducts = [];
  
  /// Lista de productos filtrados
  List<Product> _filteredProducts = [];
  
  /// Lista de categorías disponibles
  List<String> _categories = [];
  
  /// Categoría seleccionada para filtrar
  String? _selectedCategory;
  
  /// Estado de carga
  bool _isLoading = true;
  
  /// Modo de vista (lista o grilla)
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carga todos los productos
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _productService.getAllProducts();
      final categories = _productService.getCategories();
      
      if (mounted) {
        setState(() {
          _allProducts = products;
          _filteredProducts = products;
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar productos'),
          ),
        );
      }
    }
  }

  /// Maneja cambios en el campo de búsqueda
  void _onSearchChanged() {
    _filterProducts();
  }

  /// Filtra productos por búsqueda y categoría
  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesSearch = query.isEmpty ||
            product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
        
        final matchesCategory = _selectedCategory == null ||
            product.category == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  /// Selecciona una categoría para filtrar
  void _selectCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterProducts();
  }

  /// Alterna entre vista de grilla y lista
  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productsTitle),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleViewMode,
            tooltip: _isGridView ? 'Vista de lista' : 'Vista de grilla',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            color: colorScheme.surface,
            child: CustomTextField(
              controller: _searchController,
              labelText: 'Buscar productos',
              hintText: 'Nombre, descripción o categoría...',
              prefixIcon: Icons.search,
              suffixIcon: _searchController.text.isNotEmpty 
                  ? Icons.clear 
                  : null,
              onSuffixPressed: () {
                _searchController.clear();
              },
            ),
          ),

          // Filtros de categoría
          if (_categories.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildCategoryChip(null, 'Todas');
                  }
                  final category = _categories[index - 1];
                  return _buildCategoryChip(category, category);
                },
              ),
            ),

          // Lista de productos
          Expanded(
            child: _buildProductsList(),
          ),
        ],
      ),
    );
  }

  /// Construye un chip de categoría
  Widget _buildCategoryChip(String? category, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          _selectCategory(selected ? category : null);
        },
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.onPrimaryContainer,
        labelStyle: TextStyle(
          color: isSelected 
              ? colorScheme.onPrimaryContainer 
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  /// Construye la lista de productos
  Widget _buildProductsList() {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_filteredProducts.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  /// Construye la vista de grilla
  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppConstants.paddingMedium,
          mainAxisSpacing: AppConstants.paddingMedium,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return ProductCard(
            product: product,
            onTap: () => widget.onNavigateToProductDetail?.call(product),
          );
        },
      ),
    );
  }

  /// Construye la vista de lista
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
          child: ProductCardHorizontal(
            product: product,
            onTap: () => widget.onNavigateToProductDetail?.call(product),
          ),
        );
      },
    );
  }

  /// Construye la vista de carga
  Widget _buildLoadingView() {
    return _isGridView 
        ? _buildLoadingGrid()
        : _buildLoadingList();
  }

  /// Construye la grilla de carga
  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppConstants.paddingMedium,
          mainAxisSpacing: AppConstants.paddingMedium,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return const ProductCard.loading();
        },
      ),
    );
  }

  /// Construye la lista de carga
  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
          child: Card(
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 14,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Construye la vista vacía
  Widget _buildEmptyView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'No se encontraron productos',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Intenta con otros términos de búsqueda',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          TextButton(
            onPressed: () {
              _searchController.clear();
              _selectCategory(null);
            },
            child: const Text('Limpiar filtros'),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de filtros
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecciona una categoría:'),
            const SizedBox(height: AppConstants.paddingMedium),
            Wrap(
              spacing: AppConstants.paddingSmall,
              children: [
                _buildDialogCategoryChip(null, 'Todas'),
                ..._categories.map((category) => 
                  _buildDialogCategoryChip(category, category)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Construye un chip de categoría para el diálogo
  Widget _buildDialogCategoryChip(String? category, String label) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        _selectCategory(selected ? category : null);
        Navigator.pop(context);
      },
    );
  }
}