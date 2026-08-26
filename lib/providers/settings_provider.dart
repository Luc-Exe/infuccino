import 'package:flutter/material.dart';

enum UnitSystem {
  metric,
  imperial;

  String get label {
    switch (this) {
      case UnitSystem.metric:
        return 'Métrico (g, ml, °C)';
      case UnitSystem.imperial:
        return 'Imperial (oz, fl oz, °F)';
    }
  }
}

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('es', 'ES');
  UnitSystem _unitSystem = UnitSystem.metric;

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  UnitSystem get unitSystem => _unitSystem;
  bool get isMetric => _unitSystem == UnitSystem.metric;

  String get aboutText => _locale.languageCode == 'en'
      ? 'Made with love ❤️ by Luc-Exe'
      : 'Hecho con amor ❤️ por Luc-Exe';
  static const String appVersion = '1.1.0';

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'es') {
      _locale = const Locale('en', 'US');
    } else {
      _locale = const Locale('es', 'ES');
    }
    notifyListeners();
  }

  void setUnitSystem(UnitSystem system) {
    if (_unitSystem != system) {
      _unitSystem = system;
      notifyListeners();
    }
  }

  void toggleUnitSystem() {
    _unitSystem = _unitSystem == UnitSystem.metric ? UnitSystem.imperial : UnitSystem.metric;
    notifyListeners();
  }

  // --- Unit Conversion & Formatting Helpers ---

  String get weightUnit => isMetric ? 'g' : 'oz';
  String get volumeUnit => isMetric ? 'ml' : 'fl oz';
  String get tempUnit => isMetric ? '°C' : '°F';

  /// Formats weight value (stored internally in grams)
  String formatWeight(double grams) {
    if (isMetric) {
      return grams == grams.roundToDouble()
          ? '${grams.toStringAsFixed(0)} g'
          : '${grams.toStringAsFixed(1)} g';
    } else {
      final oz = grams * 0.035274;
      return '${oz.toStringAsFixed(1)} oz';
    }
  }

  /// Formats volume value (stored internally in ml)
  String formatVolume(double ml) {
    if (isMetric) {
      return '${ml.toStringAsFixed(0)} ml';
    } else {
      final flOz = ml * 0.033814;
      return '${flOz.toStringAsFixed(1)} fl oz';
    }
  }

  /// Formats temperature value (stored internally in °C)
  String formatTemperature(double celsius) {
    if (isMetric) {
      return '${celsius.toStringAsFixed(0)} °C';
    } else {
      final fahrenheit = (celsius * 9 / 5) + 32;
      return '${fahrenheit.toStringAsFixed(0)} °F';
    }
  }

  // --- Translation Helper (Simple reactive dictionary for key terms) ---
  String tr(String key) {
    final isEn = _locale.languageCode == 'en';
    switch (key) {
      case 'home':
        return isEn ? 'Home' : 'Inicio';
      case 'agenda':
        return isEn ? 'Calendar' : 'Agenda';
      case 'list':
        return isEn ? 'List' : 'Lista';
      case 'stats':
        return isEn ? 'Statistics' : 'Estadísticas';
      case 'new_infusion':
        return isEn ? 'New Infusion' : 'Nueva Infusión';
      case 'quick_add':
        return isEn ? 'Quick Add' : 'Añadir Rápido';
      case 'temperature':
        return isEn ? 'Temperature' : 'Temperatura';
      case 'weight':
        return isEn ? 'Weight' : 'Peso';
      case 'volume':
        return isEn ? 'Volume' : 'Volumen';
      case 'backup':
        return isEn ? 'Backup & Data' : 'Copia de Seguridad';
      case 'export_data':
        return isEn ? 'Export Data (JSON)' : 'Exportar Datos (JSON)';
      case 'import_data':
        return isEn ? 'Import Backup (JSON)' : 'Importar Backup (JSON)';
      case 'settings':
        return isEn ? 'Settings' : 'Configuración';
      case 'language':
        return isEn ? 'Language' : 'Idioma';
      case 'units':
        return isEn ? 'Units' : 'Unidades';
      case 'about':
        return isEn ? 'About' : 'Acerca de';
      default:
        return key;
    }
  }
}
