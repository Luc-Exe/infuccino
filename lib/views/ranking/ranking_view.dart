import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../calendar/infusion_form_dialog.dart';
import '../widgets/catppuccin_card.dart';
import '../widgets/product_image_avatar.dart';
import '../widgets/settings_drawer_modal.dart';
import 'product_detail_view.dart';
import 'product_form_dialog.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final provider = Provider.of<ProductProvider>(context, listen: false);
        switch (_tabController.index) {
          case 0:
            provider.setCategoryFilter(InfusionCategory.mate);
            break;
          case 1:
            provider.setCategoryFilter(InfusionCategory.cafe);
            break;
          case 2:
            provider.setCategoryFilter(InfusionCategory.te);
            break;
          case 3:
            provider.setCategoryFilter(null);
            break;
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .setCategoryFilter(InfusionCategory.mate);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openAddProductDialog(BuildContext context, InfusionCategory category) {
    showDialog(
      context: context,
      builder: (ctx) => ProductFormDialog(initialCategory: category),
    );
  }

  void _openQuickBrew(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => InfusionFormDialog(
        initialDate: DateTime.now(),
        preselectedProduct: product,
      ),
    );
  }

  Color _getRankBadgeColor(ThemeProvider theme, int rank) {
    switch (rank) {
      case 1:
        return theme.yellowColor;
      case 2:
        return theme.lavenderColor;
      case 3:
        return theme.peachColor;
      default:
        return theme.subtextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.filteredProducts;

    final currentCategory = _tabController.index == 0
        ? InfusionCategory.mate
        : _tabController.index == 1
            ? InfusionCategory.cafe
            : _tabController.index == 2
                ? InfusionCategory.te
                : InfusionCategory.mate;

    Color currentAccent;
    switch (currentCategory) {
      case InfusionCategory.mate:
        currentAccent = theme.greenColor;
        break;
      case InfusionCategory.cafe:
        currentAccent = theme.peachColor;
        break;
      case InfusionCategory.te:
        currentAccent = theme.tealColor;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Menú & Configuración',
          icon: Icon(Icons.tune_rounded, color: theme.lavenderColor),
          onPressed: () => SettingsDrawerModal.show(context),
        ),
        title: Row(
          children: [
            Icon(Icons.format_list_numbered_rounded, color: theme.peachColor),
            const SizedBox(width: 8),
            Text(settings.languageCode == 'en' ? 'Product List' : 'Lista de Productos'),
          ],
        ),
        actions: [
          PopupMenuButton<ProductSortBy>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: settings.languageCode == 'en' ? 'Sort list' : 'Ordenar lista',
            color: theme.surfaceColor,
            onSelected: (sort) => productProvider.setSortBy(sort),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: ProductSortBy.ranking,
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 18, color: theme.peachColor),
                    const SizedBox(width: 8),
                    Text(
                      settings.languageCode == 'en' ? 'By Score / Rating' : 'Por Puntuación / Ranking',
                      style: TextStyle(color: theme.textColor),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ProductSortBy.name,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha_rounded, size: 18, color: theme.lavenderColor),
                    const SizedBox(width: 8),
                    Text(
                      settings.languageCode == 'en' ? 'Alphabetical (Name)' : 'Alfabético (Nombre)',
                      style: TextStyle(color: theme.textColor),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ProductSortBy.recentlyAdded,
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 18, color: theme.tealColor),
                    const SizedBox(width: 8),
                    Text(
                      settings.languageCode == 'en' ? 'Recently Added' : 'Más Recientes',
                      style: TextStyle(color: theme.textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.surface1Color),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: theme.surface1Color,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: theme.textColor,
              unselectedLabelColor: theme.subtextColor,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text(settings.languageCode == 'en' ? 'Mate' : 'Mate'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.coffee_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text(settings.languageCode == 'en' ? 'Coffee' : 'Café'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_food_beverage_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text(settings.languageCode == 'en' ? 'Tea' : 'Té'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_outline_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text(settings.languageCode == 'en' ? 'All' : 'Todos'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: currentAccent,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add_photo_alternate_rounded),
        label: Text(
          currentCategory == InfusionCategory.mate
              ? (settings.languageCode == 'en' ? 'New Yerba' : 'Nueva Yerba')
              : currentCategory == InfusionCategory.cafe
                  ? (settings.languageCode == 'en' ? 'New Coffee' : 'Nuevo Café')
                  : (settings.languageCode == 'en' ? 'New Tea' : 'Nuevo Té'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _openAddProductDialog(context, currentCategory),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: settings.languageCode == 'en'
                    ? 'Search by name, brand, tasting notes or origin...'
                    : 'Buscar por nombre, marca, notas de cata u origen...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          productProvider.setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) {
                productProvider.setSearchQuery(val);
                setState(() {});
              },
            ),
          ),

          // Product List
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState(theme, settings)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final rank = index + 1;
                      return _buildProductCard(context, theme, product, rank);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeProvider theme, SettingsProvider settings) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.subtextColor.withAlpha(120),
            ),
            const SizedBox(height: 12),
            Text(
              settings.languageCode == 'en' ? 'No products found' : 'No se encontraron productos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              settings.languageCode == 'en'
                  ? 'Try another search or add a new product with photos and rating.'
                  : 'Prueba con otra búsqueda o agrega un nuevo producto a la lista con fotos y calificación.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.subtextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ThemeProvider theme,
    Product product,
    int rank,
  ) {
    final badgeColor = _getRankBadgeColor(theme, rank);

    Color accentColor;
    switch (product.category) {
      case InfusionCategory.mate:
        accentColor = theme.greenColor;
        break;
      case InfusionCategory.cafe:
        accentColor = theme.peachColor;
        break;
      case InfusionCategory.te:
        accentColor = theme.tealColor;
        break;
    }

    return CatppuccinCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ProductDetailView(product: product),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rank Badge (#1, #2, #3, ...)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? badgeColor.withAlpha(theme.isDark ? 45 : 30)
                  : theme.surface1Color,
              shape: BoxShape.circle,
              border: rank <= 3
                  ? Border.all(color: badgeColor, width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: rank <= 3 ? badgeColor : theme.subtextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Photo / Avatar
          ProductImageAvatar(
            imagePath: product.imagePath,
            category: product.category,
            size: 60,
            borderRadius: 12,
          ),
          const SizedBox(width: 12),

          // Main Info: Name, Brand, Rating & Notes
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: theme.peachColor),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (product.brand.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    product.brand + (product.origin.isNotEmpty ? ' • ${product.origin}' : ''),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.subtextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),

                // Tasting Notes Tags
                if (product.tastingNotes.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: product.tastingNotes.take(3).map((note) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(theme.isDark ? 25 : 18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          note,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.textColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Quick Brew Action Button
          IconButton(
            tooltip: 'Preparar ahora',
            icon: Icon(
              product.category.icon,
              color: accentColor,
            ),
            onPressed: () => _openQuickBrew(context, product),
          ),
        ],
      ),
    );
  }
}
