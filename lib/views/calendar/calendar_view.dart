import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/infusion_log.dart';
import '../../models/infusion_type.dart';
import '../../providers/infusion_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/catppuccin_card.dart';
import '../widgets/infusion_badge.dart';
import '../widgets/product_image_avatar.dart';
import '../widgets/rating_stars.dart';
import '../widgets/settings_drawer_modal.dart';
import 'infusion_form_dialog.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _openAddDialog(BuildContext context, DateTime initialDate) {
    showDialog(
      context: context,
      builder: (ctx) => InfusionFormDialog(initialDate: initialDate),
    );
  }

  void _openEditDialog(BuildContext context, InfusionLog log) {
    showDialog(
      context: context,
      builder: (ctx) => InfusionFormDialog(existingLog: log),
    );
  }

  void _confirmDeleteLog(BuildContext context, InfusionLog log) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isEn = settings.languageCode == 'en';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isEn ? 'Delete infusion?' : '¿Eliminar infusión?',
          style: TextStyle(color: theme.textColor),
        ),
        content: Text(
          isEn
              ? 'Are you sure you want to delete "${log.productName}" from ${DateFormat('MM/dd/yyyy HH:mm').format(log.dateTime)}?'
              : 'Se eliminará el registro de "${log.productName}" del ${DateFormat('dd/MM/yyyy HH:mm').format(log.dateTime)}.',
          style: TextStyle(color: theme.subtextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isEn ? 'Cancel' : 'Cancelar', style: TextStyle(color: theme.subtextColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: theme.redColor),
            onPressed: () {
              Provider.of<InfusionProvider>(context, listen: false).deleteLog(log.id);
              Navigator.of(ctx).pop();
            },
            child: Text(isEn ? 'Delete' : 'Eliminar', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isEn = settings.languageCode == 'en';
    final infusionProvider = Provider.of<InfusionProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final selectedDay = infusionProvider.selectedDay;
    final focusedDay = infusionProvider.focusedDay;
    final dayLogs = infusionProvider.logsForSelectedDay;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: isEn ? 'Menu & Settings' : 'Menú & Configuración',
          icon: Icon(Icons.tune_rounded, color: theme.lavenderColor),
          onPressed: () => SettingsDrawerModal.show(context),
        ),
        title: Row(
          children: [
            Icon(Icons.calendar_month_rounded, color: theme.lavenderColor),
            const SizedBox(width: 8),
            Text(isEn ? 'Infusion Agenda' : 'Agenda de Infusiones'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isEn ? 'Go to Today' : 'Ir a Hoy',
            icon: const Icon(Icons.today_rounded),
            onPressed: () {
              final now = DateTime.now();
              infusionProvider.setSelectedDay(now, now);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.lavenderColor,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          isEn ? 'New Infusion' : 'Registrar Infusión',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _openAddDialog(context, selectedDay),
      ),
      body: Column(
        children: [
          // Table Calendar Container
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.surface1Color),
            ),
            child: TableCalendar<InfusionLog>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2035, 12, 31),
              focusedDay: focusedDay,
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              eventLoader: (day) => infusionProvider.getEventsForDay(day),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: theme.surface1Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                formatButtonTextStyle: TextStyle(
                  color: theme.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                titleTextStyle: TextStyle(
                  color: theme.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: theme.textColor),
                rightChevronIcon: Icon(Icons.chevron_right, color: theme.textColor),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle: TextStyle(color: theme.textColor),
                weekendTextStyle: TextStyle(color: theme.peachColor),
                todayDecoration: BoxDecoration(
                  color: theme.lavenderColor.withAlpha(50),
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.lavenderColor, width: 1.5),
                ),
                todayTextStyle: TextStyle(
                  color: theme.lavenderColor,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.lavenderColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return null;

                  final hasMate = events.any((e) => e.category == InfusionCategory.mate);
                  final hasCafe = events.any((e) => e.category == InfusionCategory.cafe);
                  final hasTe = events.any((e) => e.category == InfusionCategory.te);

                  return Positioned(
                    bottom: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasMate)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              color: theme.greenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (hasCafe)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              color: theme.peachColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (hasTe)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              color: theme.tealColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              onDaySelected: (newSelected, newFocused) {
                infusionProvider.setSelectedDay(newSelected, newFocused);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focused) {
                infusionProvider.setFocusedDay(focused);
              },
            ),
          ),

          // Day Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM', settings.languageCode).format(selectedDay).toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: theme.lavenderColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (isSameDay(selectedDay, DateTime.now())) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.lavenderColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                           isEn ? 'TODAY' : 'HOY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.lavenderColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${dayLogs.length} ${dayLogs.length == 1 ? (isEn ? "infusion" : "infusión") : (isEn ? "infusions" : "infusiones")}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.subtextColor,
                  ),
                ),
              ],
            ),
          ),

          // Day Logs List
          Expanded(
            child: dayLogs.isEmpty
                ? _buildEmptyState(theme, settings, selectedDay)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: dayLogs.length,
                    itemBuilder: (context, index) {
                      final log = dayLogs[index];
                      final matchedProduct = productProvider.getProductById(log.productId);

                      return _buildLogCard(context, theme, settings, log, matchedProduct);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeProvider theme, SettingsProvider settings, DateTime date) {
    final isEn = settings.languageCode == 'en';
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee_maker_outlined,
              size: 64,
              color: theme.subtextColor.withAlpha(120),
            ),
            const SizedBox(height: 12),
            Text(
              isEn ? 'No infusions recorded' : 'Sin infusiones registradas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEn
                  ? 'No records for this day.\nTap the + button to log a session!'
                  : 'No hay registros de mate, café o té para este día.\n¡Presiona el botón + para registrar uno!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.subtextColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.lavenderColor,
                side: BorderSide(color: theme.lavenderColor.withAlpha(120)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _openAddDialog(context, date),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: Text(isEn ? 'Log Now' : 'Registrar ahora'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(
    BuildContext context,
    ThemeProvider theme,
    SettingsProvider settings,
    InfusionLog log,
    dynamic matchedProduct,
  ) {
    final isEn = settings.languageCode == 'en';
    final timeStr = DateFormat('HH:mm').format(log.dateTime);

    return CatppuccinCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      onTap: () => _openEditDialog(context, log),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Time, Type Badge, Context Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Time Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.surface1Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: theme.subtextColor),
                    const SizedBox(width: 4),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Specific Infusion Type Badge
              InfusionBadge(type: log.type),

              const Spacer(),

              // Quick Actions Menu
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, size: 18, color: theme.subtextColor),
                color: theme.surfaceColor,
                onSelected: (action) {
                  if (action == 'edit') {
                    _openEditDialog(context, log);
                  } else if (action == 'duplicate') {
                    Provider.of<InfusionProvider>(context, listen: false).duplicateLog(log);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEn ? 'Infusion duplicated for today' : 'Infusión duplicada para hoy')),
                    );
                  } else if (action == 'delete') {
                    _confirmDeleteLog(context, log);
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18, color: theme.lavenderColor),
                        const SizedBox(width: 8),
                        Text(isEn ? 'Edit' : 'Editar', style: TextStyle(color: theme.textColor)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy_rounded, size: 18, color: theme.peachColor),
                        const SizedBox(width: 8),
                        Text(isEn ? 'Duplicate' : 'Duplicar', style: TextStyle(color: theme.textColor)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 18, color: theme.redColor),
                        const SizedBox(width: 8),
                        Text(isEn ? 'Delete' : 'Eliminar', style: TextStyle(color: theme.redColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Main Info: Image / Icon + Product Name & Rating
          Row(
            children: [
              ProductImageAvatar(
                imagePath: matchedProduct?.imagePath,
                category: log.category,
                size: 46,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.productName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (matchedProduct != null && matchedProduct.brand.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        matchedProduct.brand,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.subtextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              RatingStars(
                rating: log.rating,
                size: 16,
                showLabel: true,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Preparation Metrics Chips: Weight & Temperature with Unit conversion
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.mantleColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Weight
                Row(
                  children: [
                    Icon(Icons.scale_rounded, size: 16, color: theme.lavenderColor),
                    const SizedBox(width: 6),
                    Text(
                      '${settings.formatWeight(log.weightGrams)} ${log.category.shortLabelFor(settings.languageCode).toLowerCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 14, color: theme.surface1Color),

                // Volume (if recorded)
                if (log.waterVolumeMl != null) ...[
                  Row(
                    children: [
                      Icon(Icons.water_drop_rounded, size: 16, color: theme.tealColor),
                      const SizedBox(width: 4),
                      Text(
                        settings.formatVolume(log.waterVolumeMl!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.textColor,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 14, color: theme.surface1Color),
                ],

                // Temperature
                Row(
                  children: [
                    Icon(
                      Icons.thermostat_rounded,
                      size: 16,
                      color: log.temperatureCelsius <= 15
                          ? theme.tealColor
                          : log.temperatureCelsius <= 85
                              ? theme.greenColor
                              : theme.peachColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      settings.formatTemperature(log.temperatureCelsius),
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
          ),

          // Notes
          if (log.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '💬 "${log.notes}"',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: theme.subtextColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
