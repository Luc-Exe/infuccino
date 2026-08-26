import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/backup_service.dart';
import '../../theme/app_theme.dart';
import 'catppuccin_card.dart';

class SettingsDrawerModal extends StatelessWidget {
  const SettingsDrawerModal({super.key});

  static void show(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const SettingsDrawerModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isEn = settings.languageCode == 'en';

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal Notch Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.surface1Color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title & Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tune_rounded, color: theme.lavenderColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        isEn ? 'Settings & Options' : 'Configuración & Opciones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 20),

              // 1. Idioma (Language)
              Text(
                isEn ? 'Language' : 'Idioma / Language',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.subtextColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      avatar: Text('🇦🇷', style: const TextStyle(fontSize: 14)),
                      label: Center(
                        child: Text(
                           isEn ? 'Spanish (AR)' : 'Español (AR)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: settings.languageCode == 'es' ? Colors.black87 : theme.textColor,
                          ),
                        ),
                      ),
                      selected: settings.languageCode == 'es',
                      selectedColor: theme.lavenderColor,
                      backgroundColor: theme.surface1Color,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onSelected: (selected) {
                        if (selected) settings.setLocale(const Locale('es', 'ES'));
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      avatar: Text('🇬🇧', style: const TextStyle(fontSize: 14)),
                      label: Center(
                        child: Text(
                          'English (EN)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: settings.languageCode == 'en' ? Colors.black87 : theme.textColor,
                          ),
                        ),
                      ),
                      selected: settings.languageCode == 'en',
                      selectedColor: theme.lavenderColor,
                      backgroundColor: theme.surface1Color,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onSelected: (selected) {
                        if (selected) settings.setLocale(const Locale('en', 'US'));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. Sistema de Medidas (Units)
              Text(
                isEn ? 'Measurement System' : 'Sistema de Medidas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.subtextColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      avatar: const Icon(Icons.straighten_rounded, size: 16),
                      label: Center(
                        child: Text(
                           isEn ? 'Metric (g, ml, °C)' : 'Métrico (g, ml, °C)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: settings.isMetric ? Colors.black87 : theme.textColor,
                          ),
                        ),
                      ),
                      selected: settings.isMetric,
                      selectedColor: theme.peachColor,
                      backgroundColor: theme.surface1Color,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onSelected: (selected) {
                        if (selected) settings.setUnitSystem(UnitSystem.metric);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      avatar: const Icon(Icons.scale_outlined, size: 16),
                      label: Center(
                        child: Text(
                          'Imperial (oz, fl oz, °F)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: !settings.isMetric ? Colors.black87 : theme.textColor,
                          ),
                        ),
                      ),
                      selected: !settings.isMetric,
                      selectedColor: theme.peachColor,
                      backgroundColor: theme.surface1Color,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onSelected: (selected) {
                        if (selected) settings.setUnitSystem(UnitSystem.imperial);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 3. Selector de Temas Visuales
              Text(
                isEn ? 'Visual Theme' : 'Tema Visual',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.subtextColor,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppThemeType.values.map((type) {
                  final isSelected = theme.currentThemeType == type;
                  return ChoiceChip(
                    avatar: Icon(
                      type.icon,
                      size: 16,
                      color: isSelected ? Colors.black87 : theme.textColor,
                    ),
                    label: Text(type.label),
                    selected: isSelected,
                    selectedColor: theme.lavenderColor,
                    backgroundColor: theme.surface1Color,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black87 : theme.textColor,
                    ),
                    onSelected: (selected) {
                      if (selected) theme.setThemeType(type);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // 4. Copia de Seguridad & Persistencia (Anti-borrado)
              Text(
                isEn ? 'Backup & Persistence' : 'Copia de Seguridad & Persistencia',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.subtextColor,
                ),
              ),
              const SizedBox(height: 8),
              CatppuccinCard(
                padding: const EdgeInsets.all(12),
                customColor: theme.mantleColor,
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.greenColor.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.file_download_rounded, color: theme.greenColor, size: 20),
                      ),
                      title: Text(
                        isEn ? 'Export Data (JSON)' : 'Exportar Datos (JSON)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      subtitle: Text(
                        isEn
                            ? 'Save all your infusions, products, and lists to a .json file'
                            : 'Guarda todas tus infusiones, productos y lista en un archivo .json',
                        style: TextStyle(fontSize: 11, color: theme.subtextColor),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () async {
                        final success = await BackupService.instance.exportBackup(context);
                        if (context.mounted && success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(isEn ? 'Backup exported successfully' : 'Copia de respaldo exportada exitosamente')),
                            );
                        }
                      },
                    ),
                    Divider(height: 12, color: theme.surface1Color),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.peachColor.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.file_upload_rounded, color: theme.peachColor, size: 20),
                      ),
                      title: Text(
                        isEn ? 'Import Backup (JSON)' : 'Importar Backup (JSON)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      subtitle: Text(
                        isEn
                            ? 'Restore your saved data from a previous file'
                            : 'Restaura tus datos guardados desde un archivo previo',
                        style: TextStyle(fontSize: 11, color: theme.subtextColor),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () async {
                        final result = await BackupService.instance.importBackup(context);
                        if (context.mounted && result != null) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (dialogCtx) => AlertDialog(
                              title: Text(
                                result.startsWith('SUCCESS')
                                    ? (isEn ? 'Restore complete' : '¡Restauración Exitosa!')
                                    : (isEn ? 'Notice' : 'Aviso'),
                                style: TextStyle(color: theme.textColor),
                              ),
                              content: Text(
                                result.replaceFirst('SUCCESS: ', ''),
                                style: TextStyle(color: theme.subtextColor),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(dialogCtx).pop(),
                                  child: Text(isEn ? 'Got it' : 'Entendido'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. Acerca de (Info)
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'assets/icon/app_icon.jpg',
                            width: 22,
                            height: 22,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.coffee, size: 18),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Infuccino v${SettingsProvider.appVersion}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      settings.aboutText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.peachColor,
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
  }
}
