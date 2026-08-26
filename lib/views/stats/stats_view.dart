import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../providers/infusion_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/catppuccin_card.dart';
import '../widgets/infusion_badge.dart';
import '../widgets/settings_drawer_modal.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isEn = settings.languageCode == 'en';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: isEn ? 'Menu & Settings' : 'Menú & Configuración',
          icon: Icon(Icons.tune_rounded, color: theme.lavenderColor),
          onPressed: () => SettingsDrawerModal.show(context),
        ),
        title: Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: theme.tealColor),
            const SizedBox(width: 8),
            Text(isEn ? 'Statistics & Overview' : 'Estadísticas & Resumen'),
          ],
        ),
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
                      const Icon(Icons.analytics_outlined, size: 15),
                      const SizedBox(width: 4),
                      Text(isEn ? 'Overview' : 'General'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text(isEn ? 'Mate' : 'Mate'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.coffee_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text(isEn ? 'Coffee' : 'Café'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_food_beverage_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text(isEn ? 'Tea' : 'Té'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(context, theme, settings),
          _buildCategoryTab(context, theme, settings, InfusionCategory.mate),
          _buildCategoryTab(context, theme, settings, InfusionCategory.cafe),
          _buildCategoryTab(context, theme, settings, InfusionCategory.te),
        ],
      ),
    );
  }

  // Tab 1: General Stats
  Widget _buildGeneralTab(BuildContext context, ThemeProvider theme, SettingsProvider settings) {
    final isEn = settings.languageCode == 'en';
    final infusionProvider = Provider.of<InfusionProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final total = infusionProvider.totalCount;
    final mateCount = infusionProvider.mateCount;
    final cafeCount = infusionProvider.cafeCount;
    final teCount = infusionProvider.teCount;
    final avgTemp = infusionProvider.averageTemperature;
    final avgWeight = infusionProvider.averageWeight;
    final avgRating = infusionProvider.averageRating;
    final favoriteType = infusionProvider.favoriteType;
    final typeDist = infusionProvider.typeDistribution;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Counter Cards
          Row(
            children: [
              Expanded(
                child: CatppuccinCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEn ? 'Total Sessions' : 'Total Sesiones',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.subtextColor),
                          ),
                          Icon(Icons.local_cafe_rounded, size: 20, color: theme.lavenderColor),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$total',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEn ? '$mateCount mates • $cafeCount coffees • $teCount teas' : '$mateCount mates • $cafeCount cafés • $teCount tés',
                        style: TextStyle(fontSize: 11, color: theme.subtextColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CatppuccinCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEn ? 'In List' : 'En Lista',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.subtextColor),
                          ),
                          Icon(Icons.inventory_2_rounded, size: 20, color: theme.peachColor),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${productProvider.allProducts.length}',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEn ? 'Products registered' : 'Productos registrados',
                        style: TextStyle(fontSize: 11, color: theme.subtextColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3-Color Beverage Proportion Bar
          if (total > 0) ...[
            CatppuccinCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEn ? 'Global Consumption Breakdown' : 'Distribución Global de Consumo',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textColor),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        if (mateCount > 0)
                          Expanded(
                            flex: mateCount,
                            child: Container(height: 16, color: theme.greenColor),
                          ),
                        if (cafeCount > 0)
                          Expanded(
                            flex: cafeCount,
                            child: Container(height: 16, color: theme.peachColor),
                          ),
                        if (teCount > 0)
                          Expanded(
                            flex: teCount,
                            child: Container(height: 16, color: theme.tealColor),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _buildLegendDot(theme.greenColor, isEn ? 'Mate: ${((mateCount / total) * 100).toStringAsFixed(0)}% ($mateCount)' : 'Mate: ${((mateCount / total) * 100).toStringAsFixed(0)}% ($mateCount)', theme),
                      _buildLegendDot(theme.peachColor, isEn ? 'Coffee: ${((cafeCount / total) * 100).toStringAsFixed(0)}% ($cafeCount)' : 'Café: ${((cafeCount / total) * 100).toStringAsFixed(0)}% ($cafeCount)', theme),
                      _buildLegendDot(theme.tealColor, isEn ? 'Tea: ${((teCount / total) * 100).toStringAsFixed(0)}% ($teCount)' : 'Té: ${((teCount / total) * 100).toStringAsFixed(0)}% ($teCount)', theme),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Global Extraction Metrics with unit conversion
          CatppuccinCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    isEn ? 'Global Averages' : 'Promedios Globales',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textColor),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricItem(
                      theme: theme,
                      icon: Icons.thermostat_rounded,
                      color: theme.peachColor,
                       title: isEn ? 'Temperature' : 'Temperatura',
                      value: total > 0 ? settings.formatTemperature(avgTemp) : '-',
                    ),
                    Container(width: 1, height: 40, color: theme.surface1Color),
                    _buildMetricItem(
                      theme: theme,
                      icon: Icons.scale_rounded,
                      color: theme.lavenderColor,
                       title: isEn ? 'Avg Weight' : 'Peso Promedio',
                      value: total > 0 ? settings.formatWeight(avgWeight) : '-',
                    ),
                    Container(width: 1, height: 40, color: theme.surface1Color),
                    _buildMetricItem(
                      theme: theme,
                      icon: Icons.star_rounded,
                      color: theme.yellowColor,
                       title: isEn ? 'Rating' : 'Calificación',
                      value: avgRating > 0 ? avgRating.toStringAsFixed(1) : '-',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Favorite Overall Method
          if (favoriteType != null) ...[
            CatppuccinCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.lavenderColor.withAlpha(theme.isDark ? 40 : 25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_rounded, color: theme.lavenderColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                           isEn ? 'Most Frequent Method' : 'Método Más Frecuente',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.subtextColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                           favoriteType.labelFor(settings.languageCode),
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: theme.textColor),
                        ),
                      ],
                    ),
                  ),
                  InfusionBadge(type: favoriteType),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Breakdown by Infusion Types
          CatppuccinCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    isEn ? 'Breakdown by Infusion Type' : 'Desglose por Tipo de Infusión',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textColor),
                ),
                const SizedBox(height: 14),
                ...InfusionType.values.map((type) {
                  final count = typeDist[type] ?? 0;
                  final pct = total > 0 ? count / total : 0.0;

                  Color typeColor;
                  switch (type.category) {
                    case InfusionCategory.mate:
                      typeColor = theme.greenColor;
                      break;
                    case InfusionCategory.cafe:
                      typeColor = theme.peachColor;
                      break;
                    case InfusionCategory.te:
                      typeColor = theme.tealColor;
                      break;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(type.icon, size: 16, color: typeColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                type.labelFor(settings.languageCode),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.textColor),
                              ),
                            ),
                            Text(
                                '$count ${count == 1 ? (isEn ? "session" : "sesión") : (isEn ? "sessions" : "sesiones")}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.textColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 6,
                            backgroundColor: theme.surface1Color,
                            valueColor: AlwaysStoppedAnimation<Color>(typeColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tabs 2, 3, 4: Specific Category Stats
  Widget _buildCategoryTab(
    BuildContext context,
    ThemeProvider theme,
    SettingsProvider settings,
    InfusionCategory category,
  ) {
    final isEn = settings.languageCode == 'en';
    final infusionProvider = Provider.of<InfusionProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final catLogs = infusionProvider.logsForCategory(category);
    final totalCat = catLogs.length;
    final avgTemp = infusionProvider.averageTempForCategory(category);
    final avgWeight = infusionProvider.averageWeightForCategory(category);
    final avgRating = infusionProvider.averageRatingForCategory(category);
    final favType = infusionProvider.favoriteTypeForCategory(category);

    final relevantProducts = productProvider.allProducts.where((p) => p.category == category).toList();

    Color accentColor;
    switch (category) {
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

    final relevantTypes = InfusionType.values.where((t) => t.category == category).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          CatppuccinCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(theme.isDark ? 40 : 25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, size: 32, color: accentColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.labelFor(settings.languageCode),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEn
                            ? '$totalCat ${totalCat == 1 ? "session" : "sessions"} logged • ${relevantProducts.length} in list'
                            : '$totalCat ${totalCat == 1 ? "sesión registrada" : "sesiones registradas"} • ${relevantProducts.length} en lista',
                        style: TextStyle(fontSize: 12, color: theme.subtextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Extraction Metrics for this beverage with unit conversion
          CatppuccinCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn
                      ? 'Extraction Averages (${category.shortLabelFor(settings.languageCode)})'
                      : 'Promedios de Extracción (${category.shortLabelFor(settings.languageCode)})',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textColor),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricItem(
                      theme: theme,
                      icon: Icons.thermostat_rounded,
                      color: accentColor,
                      title: isEn ? 'Temperature' : 'Temperatura',
                      value: totalCat > 0 ? settings.formatTemperature(avgTemp) : '-',
                    ),
                    Container(width: 1, height: 40, color: theme.surface1Color),
                    _buildMetricItem(
                      theme: theme,
                      icon: Icons.scale_rounded,
                      color: theme.lavenderColor,
                      title: isEn ? 'Avg Weight' : 'Peso Promedio',
                      value: totalCat > 0 ? settings.formatWeight(avgWeight) : '-',
                    ),
                    Container(width: 1, height: 40, color: theme.surface1Color),
                    _buildMetricItem(
                      theme: theme,
                      icon: Icons.star_rounded,
                      color: theme.yellowColor,
                      title: isEn ? 'Rating' : 'Calificación',
                      value: avgRating > 0 ? avgRating.toStringAsFixed(1) : '-',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Favorite Type for this beverage
          if (favType != null) ...[
            CatppuccinCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(favType.icon, size: 24, color: accentColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                           isEn
                               ? 'Most brewed ${category.shortLabelFor(settings.languageCode).toLowerCase()}'
                               : 'Tipo de ${category.shortLabelFor(settings.languageCode)} más preparado',
                          style: TextStyle(fontSize: 12, color: theme.subtextColor),
                        ),
                        Text(
                           favType.labelFor(settings.languageCode),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textColor),
                        ),
                      ],
                    ),
                  ),
                  InfusionBadge(type: favType),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Breakdown of methods in this category
          CatppuccinCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Methods of ${category.labelFor(settings.languageCode)}' : 'Métodos de ${category.labelFor(settings.languageCode)}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textColor),
                ),
                const SizedBox(height: 14),
                ...relevantTypes.map((type) {
                  final count = catLogs.where((l) => l.type == type).length;
                  final pct = totalCat > 0 ? count / totalCat : 0.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(type.icon, size: 16, color: accentColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                type.labelFor(settings.languageCode),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.textColor),
                              ),
                            ),
                            Text(
                              '$count ${count == 1 ? (isEn ? "session" : "sesión") : (isEn ? "sessions" : "sesiones")} (${(pct * 100).toStringAsFixed(0)}%)',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.textColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 6,
                            backgroundColor: theme.surface1Color,
                            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Top Products in this category
          CatppuccinCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Top in List (${category.labelFor(settings.languageCode)})' : 'Top en Lista (${category.labelFor(settings.languageCode)})',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textColor),
                ),
                const SizedBox(height: 10),
                if (relevantProducts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                       isEn
                           ? 'No products added in this category.'
                           : 'No hay productos agregados en esta categoría.',
                      style: TextStyle(color: theme.subtextColor, fontSize: 13),
                    ),
                  )
                else
                  ...relevantProducts.take(3).map((prod) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(category.icon, size: 16, color: accentColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${prod.name} (${prod.brand})',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.textColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '★ ${prod.rating.toStringAsFixed(1)}',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.peachColor),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text, ThemeProvider theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 12, color: theme.textColor)),
      ],
    );
  }

  Widget _buildMetricItem({
    required ThemeProvider theme,
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: theme.subtextColor,
          ),
        ),
      ],
    );
  }
}
