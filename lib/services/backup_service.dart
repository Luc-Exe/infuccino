import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/infusion_log.dart';
import '../models/infusion_type.dart';
import '../models/product.dart';
import '../providers/infusion_provider.dart';
import '../providers/product_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'database_service.dart';

class BackupService {
  static final BackupService instance = BackupService._internal();
  BackupService._internal();

  /// Exports all application data (products, logs, settings, theme) to a formatted JSON file and prompts sharing/saving
  Future<bool> exportBackup(BuildContext context) async {
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final infusionProvider = Provider.of<InfusionProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      final products = productProvider.allProducts;
      final logs = infusionProvider.allLogs;

      final backupData = {
        'version': '1.1.0',
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'appName': 'Infuccino',
        'data': {
          'products': products.map((p) => p.toMap()).toList(),
          'cafes': products.where((p) => p.category == InfusionCategory.cafe).map((p) => p.toMap()).toList(),
          'yerbas': products.where((p) => p.category == InfusionCategory.mate).map((p) => p.toMap()).toList(),
          'tes': products.where((p) => p.category == InfusionCategory.te).map((p) => p.toMap()).toList(),
          'calendar': logs.map((l) => l.toMap()).toList(),
        },
        'settings': {
          'language': settingsProvider.languageCode,
          'units': settingsProvider.unitSystem.name,
          'theme': themeProvider.currentThemeType.name,
        },
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

      final tempDir = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
      final filePath = '${tempDir.path}/backup_infuccino_$dateStr.json';

      final file = File(filePath);
      await file.writeAsString(jsonString);

      // Share or save the file
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath, mimeType: 'application/json')],
          subject: 'Copia de Seguridad - Infuccino',
          text: 'Copia de respaldo de datos de Infuccino ($dateStr)',
        ),
      );

      return result.status == ShareResultStatus.success || result.status == ShareResultStatus.dismissed;
    } catch (e) {
      debugPrint('Error exportando respaldo JSON: $e');
      return false;
    }
  }

  /// Imports and restores data from a selected JSON backup file
  Future<String?> importBackup(BuildContext context) async {
    try {
      final selectedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (selectedFiles.isEmpty || selectedFiles.first.path == null) {
        return null; // User cancelled
      }

      final file = File(selectedFiles.first.path!);
      final content = await file.readAsString();
      final dynamic decoded = jsonDecode(content);

      if (decoded is! Map<String, dynamic> || !decoded.containsKey('data')) {
        return 'El archivo seleccionado no tiene un formato de respaldo válido de Infuccino.';
      }

      final data = decoded['data'] as Map<String, dynamic>;
      final db = DatabaseService.instance;

      int productsRestored = 0;
      int logsRestored = 0;

      // Restore products
      if (data.containsKey('products') && data['products'] is List) {
        final rawProducts = data['products'] as List;
        for (var item in rawProducts) {
          if (item is Map<String, dynamic>) {
            final prod = Product.fromMap(item);
            await db.insertProduct(prod);
            productsRestored++;
          }
        }
      }

      // Restore calendar logs
      if (data.containsKey('calendar') && data['calendar'] is List) {
        final rawLogs = data['calendar'] as List;
        for (var item in rawLogs) {
          if (item is Map<String, dynamic>) {
            final log = InfusionLog.fromMap(item);
            await db.insertLog(log);
            logsRestored++;
          }
        }
      }

      // Check context before using it after await
      if (!context.mounted) return 'SUCCESS';

      // Restore settings if present
      if (decoded.containsKey('settings') && decoded['settings'] is Map) {
        final settings = decoded['settings'] as Map<String, dynamic>;
        final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

        if (settings['language'] == 'en') {
          settingsProvider.setLocale(const Locale('en', 'US'));
        } else if (settings['language'] == 'es') {
          settingsProvider.setLocale(const Locale('es', 'ES'));
        }

        if (settings['units'] == 'imperial') {
          settingsProvider.setUnitSystem(UnitSystem.imperial);
        } else if (settings['units'] == 'metric') {
          settingsProvider.setUnitSystem(UnitSystem.metric);
        }

        if (settings['theme'] != null) {
          try {
            final themeType = AppThemeType.values.firstWhere(
              (t) => t.name.toLowerCase() == settings['theme'].toString().toLowerCase(),
            );
            themeProvider.setThemeType(themeType);
          } catch (_) {}
        }
      }

      if (!context.mounted) return 'SUCCESS';

      // Reload providers to refresh all UI
      await Provider.of<ProductProvider>(context, listen: false).loadProducts();
      if (!context.mounted) return 'SUCCESS';
      await Provider.of<InfusionProvider>(context, listen: false).loadLogs();

      return 'SUCCESS: $productsRestored productos y $logsRestored sesiones restauradas.';
    } catch (e) {
      debugPrint('Error importando respaldo JSON: $e');
      return 'Error al procesar el archivo de respaldo: $e';
    }
  }
}
