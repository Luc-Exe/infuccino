import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../providers/infusion_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../calendar/infusion_form_dialog.dart';
import '../widgets/catppuccin_card.dart';
import '../widgets/infusion_badge.dart';
import '../widgets/settings_drawer_modal.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onNavigateToAgenda;
  final VoidCallback? onNavigateToLista;

  const HomeView({
    super.key,
    this.onNavigateToAgenda,
    this.onNavigateToLista,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentBeverageIndex = 0;

  final List<Map<String, dynamic>> _beverages = [
    {
      'category': InfusionCategory.mate,
      'title': 'Yerba Mate',
      'subtitle': 'Mate Tradicional & Mate de Leche',
      'icon': Icons.eco_rounded,
      'tempC': 78.0,
      'weightG': 35.0,
      'description': 'Disfruta de una buena cebada artesanal.',
    },
    {
      'category': InfusionCategory.cafe,
      'title': 'Café de Especialidad',
      'subtitle': 'Espresso, V60, Drip, French Press & Moka',
      'icon': Icons.coffee_rounded,
      'tempC': 93.0,
      'weightG': 18.0,
      'description': 'Extracciones limpias y aromáticas.',
    },
    {
      'category': InfusionCategory.te,
      'title': 'Té & Blends',
      'subtitle': 'Té en Hebras & Saquitos',
      'icon': Icons.emoji_food_beverage_rounded,
      'tempC': 85.0,
      'weightG': 3.5,
      'description': 'Infusiones botánicas, verdes y negras.',
    },
  ];

  void _openQuickAdd(BuildContext context, InfusionCategory category) {
    showDialog(
      context: context,
      builder: (ctx) => InfusionFormDialog(
        initialDate: DateTime.now(),
        initialCategory: category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final infusionProvider = Provider.of<InfusionProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final today = DateTime.now();
    final todayLogs = infusionProvider.allLogs.where((log) {
      return log.dateTime.year == today.year &&
          log.dateTime.month == today.month &&
          log.dateTime.day == today.day;
    }).toList();

    final recentLogs = infusionProvider.allLogs.take(3).toList();
    final currentBev = _beverages[_currentBeverageIndex];
    final currentCat = currentBev['category'] as InfusionCategory;

    Color activeAccent;
    switch (currentCat) {
      case InfusionCategory.mate:
        activeAccent = theme.greenColor;
        break;
      case InfusionCategory.cafe:
        activeAccent = theme.peachColor;
        break;
      case InfusionCategory.te:
        activeAccent = theme.tealColor;
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/icon/app_icon.jpg',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.local_cafe_rounded, color: theme.lavenderColor),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Infuccino',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: theme.textColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cambiar Tema Rápido',
            icon: Icon(theme.currentThemeType.icon, color: theme.peachColor),
            onPressed: () => theme.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Welcome Subtext
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.languageCode == 'en' ? 'Swipe to choose your beverage' : 'Desliza para elegir tu bebida',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.subtextColor,
                        ),
                      ),
                      Text(
                        settings.languageCode == 'en' ? 'What are we brewing today?' : '¿Qué preparamos hoy?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: activeAccent.withAlpha(theme.isDark ? 40 : 25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentBeverageIndex + 1} / 3',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: activeAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Interactive Swipeable Hero Carousel
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _beverages.length,
                onPageChanged: (idx) {
                  setState(() {
                    _currentBeverageIndex = idx;
                  });
                },
                itemBuilder: (context, index) {
                  final bev = _beverages[index];
                  final cat = bev['category'] as InfusionCategory;
                  final isCurrent = index == _currentBeverageIndex;

                  Color bevColor;
                  switch (cat) {
                    case InfusionCategory.mate:
                      bevColor = theme.greenColor;
                      break;
                    case InfusionCategory.cafe:
                      bevColor = theme.peachColor;
                      break;
                    case InfusionCategory.te:
                      bevColor = theme.tealColor;
                      break;
                  }

                  final tempStr = settings.formatTemperature(bev['tempC'] as double);
                  final weightStr = settings.formatWeight(bev['weightG'] as double);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: isCurrent ? 4 : 16,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isCurrent ? bevColor : theme.surface1Color,
                        width: isCurrent ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isCurrent
                              ? bevColor.withAlpha(theme.isDark ? 40 : 20)
                              : Colors.black.withAlpha(20),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: bevColor.withAlpha(theme.isDark ? 45 : 30),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(bev['icon'] as IconData, size: 30, color: bevColor),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.surface1Color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.swipe_rounded, size: 14, color: theme.subtextColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    settings.languageCode == 'en' ? 'Swipe' : 'Deslizar',
                                    style: TextStyle(fontSize: 11, color: theme.subtextColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bev['title'] as String,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: theme.textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bev['subtitle'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.subtextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.thermostat_rounded, size: 15, color: bevColor),
                                const SizedBox(width: 4),
                                Text(
                                  '~ $tempStr',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.scale_rounded, size: 15, color: theme.lavenderColor),
                                const SizedBox(width: 4),
                                Text(
                                  '~ $weightStr',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // Prominent Quick Brew Button for active swiped beverage
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeAccent,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                icon: const Icon(Icons.flash_on_rounded, size: 22),
                label: Text(
                  settings.languageCode == 'en'
                      ? 'Quick Brew ${currentBev['title']}'
                      : 'Añadir ${currentBev['title']} Rápido',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                onPressed: () => _openQuickAdd(context, currentCat),
              ),
            ),
            const SizedBox(height: 24),

            // Today's Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CatppuccinCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.today_rounded, size: 18, color: theme.lavenderColor),
                            const SizedBox(width: 6),
                            Text(
                              settings.languageCode == 'en'
                                  ? 'Today (${DateFormat('d MMM', 'en').format(today)})'
                                  : 'Hoy (${DateFormat('d MMM', 'es').format(today)})',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                            ),
                          ],
                        ),
                        if (widget.onNavigateToAgenda != null)
                          GestureDetector(
                            onTap: widget.onNavigateToAgenda,
                            child: Text(
                              settings.languageCode == 'en' ? 'View Calendar >' : 'Ver Agenda >',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.lavenderColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (todayLogs.isEmpty)
                      Text(
                        settings.languageCode == 'en'
                            ? 'No infusions logged yet today. Use the button above to add one!'
                            : 'Aún no has registrado infusiones hoy. ¡Usa el botón de arriba para registrar una!',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.subtextColor,
                        ),
                      )
                    else
                      Column(
                        children: todayLogs.map((log) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                InfusionBadge(type: log.type, fontSize: 10),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    log.productName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${settings.formatTemperature(log.temperatureCelsius)} • ${DateFormat('HH:mm').format(log.dateTime)}',
                                  style: TextStyle(fontSize: 11, color: theme.subtextColor),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recent Sessions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    settings.languageCode == 'en' ? 'Recent Preparations' : 'Últimas Preparaciones',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                  if (widget.onNavigateToLista != null)
                    GestureDetector(
                      onTap: widget.onNavigateToLista,
                      child: Text(
                        settings.languageCode == 'en'
                            ? 'View List (${productProvider.allProducts.length})'
                            : 'Ver Lista (${productProvider.allProducts.length})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.peachColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (recentLogs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  settings.languageCode == 'en'
                      ? 'No infusions recorded yet.'
                      : 'No hay infusiones registradas todavía.',
                  style: TextStyle(fontSize: 13, color: theme.subtextColor),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: recentLogs.map((log) {
                    return CatppuccinCard(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(log.type.icon, size: 20, color: theme.lavenderColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.productName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                  ),
                                ),
                                Text(
                                  '${log.type.label} • ${settings.formatWeight(log.weightGrams)} • ${settings.formatTemperature(log.temperatureCelsius)}',
                                  style: TextStyle(fontSize: 11, color: theme.subtextColor),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat('d MMM, HH:mm', settings.languageCode).format(log.dateTime),
                            style: TextStyle(fontSize: 11, color: theme.subtextColor),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
