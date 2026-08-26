import 'package:flutter/material.dart';

/// Top-level categories: Mate, Café, Té
enum InfusionCategory {
  mate,
  cafe,
  te;

  String labelFor(String languageCode) {
    final isEn = languageCode == 'en';
    switch (this) {
      case InfusionCategory.mate:
        return isEn ? 'Yerba Mate' : 'Yerba Mate';
      case InfusionCategory.cafe:
        return isEn ? 'Coffee' : 'Café';
      case InfusionCategory.te:
        return isEn ? 'Tea' : 'Té';
    }
  }

  String shortLabelFor(String languageCode) {
    final isEn = languageCode == 'en';
    switch (this) {
      case InfusionCategory.mate:
        return isEn ? 'Mate' : 'Mate';
      case InfusionCategory.cafe:
        return isEn ? 'Coffee' : 'Café';
      case InfusionCategory.te:
        return isEn ? 'Tea' : 'Té';
    }
  }

  String get label => labelFor('es');

  String get shortLabel => shortLabelFor('es');

  IconData get icon {
    switch (this) {
      case InfusionCategory.mate:
        return Icons.eco_rounded;
      case InfusionCategory.cafe:
        return Icons.coffee_rounded;
      case InfusionCategory.te:
        return Icons.emoji_food_beverage_rounded;
    }
  }

  static InfusionCategory fromString(String value) {
    return InfusionCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase() ||
          e.labelFor('es').toLowerCase() == value.toLowerCase() ||
          e.labelFor('en').toLowerCase() == value.toLowerCase() ||
          e.shortLabelFor('es').toLowerCase() == value.toLowerCase() ||
          e.shortLabelFor('en').toLowerCase() == value.toLowerCase(),
      orElse: () => InfusionCategory.mate,
    );
  }
}

/// Specific types of preparation (including new coffee varieties and corrected icons)
enum InfusionType {
  // Mate types
  mateTradicional,
  mateDeLeche,

  // Café types
  espresso,
  cafeV60,
  dripFiltrado,
  frenchPress,
  mokaPot,
  cafeInstantaneo,
  coldBrew,

  // Té types
  teSaquito,
  teHebras;

  String labelFor(String languageCode) {
    final isEn = languageCode == 'en';
    switch (this) {
      case InfusionType.mateTradicional:
        return isEn ? 'Traditional Mate' : 'Mate Tradicional';
      case InfusionType.mateDeLeche:
        return isEn ? 'Mate with Milk' : 'Mate de Leche';
      case InfusionType.espresso:
        return 'Espresso';
      case InfusionType.cafeV60:
        return isEn ? 'V60 Coffee' : 'Café V60';
      case InfusionType.dripFiltrado:
        return isEn ? 'Drip / Filtered' : 'Drip / Filtrado';
      case InfusionType.frenchPress:
        return 'French Press';
      case InfusionType.mokaPot:
        return 'Moka Pot';
      case InfusionType.cafeInstantaneo:
        return isEn ? 'Instant Coffee' : 'Café Instantáneo';
      case InfusionType.coldBrew:
        return 'Cold Brew';
      case InfusionType.teSaquito:
        return isEn ? 'Tea Bag' : 'Té en Saquito';
      case InfusionType.teHebras:
        return isEn ? 'Loose Leaf Tea' : 'Té en Hebras';
    }
  }

  String get label => labelFor('es');

  InfusionCategory get category {
    switch (this) {
      case InfusionType.mateTradicional:
      case InfusionType.mateDeLeche:
        return InfusionCategory.mate;
      case InfusionType.espresso:
      case InfusionType.cafeV60:
      case InfusionType.dripFiltrado:
      case InfusionType.frenchPress:
      case InfusionType.mokaPot:
      case InfusionType.cafeInstantaneo:
      case InfusionType.coldBrew:
        return InfusionCategory.cafe;
      case InfusionType.teSaquito:
      case InfusionType.teHebras:
        return InfusionCategory.te;
    }
  }

  IconData get icon {
    switch (this) {
      case InfusionType.mateTradicional:
        return Icons.eco_rounded;
      case InfusionType.mateDeLeche:
        return Icons.local_cafe_rounded;
      case InfusionType.espresso:
        return Icons.coffee_rounded;
      case InfusionType.cafeV60:
        return Icons.filter_alt_rounded;
      case InfusionType.dripFiltrado:
        return Icons.coffee_maker_rounded;
      case InfusionType.frenchPress:
        return Icons.local_cafe_outlined;
      case InfusionType.mokaPot:
        return Icons.fireplace_rounded;
      case InfusionType.cafeInstantaneo:
        return Icons.bolt_rounded;
      case InfusionType.coldBrew:
        return Icons.ac_unit_rounded;
      case InfusionType.teSaquito:
        return Icons.shopping_bag_outlined;
      case InfusionType.teHebras:
        return Icons.spa_rounded;
    }
  }

  /// Default suggested water/liquid temperature in °C
  double get defaultTemperature {
    switch (this) {
      case InfusionType.mateTradicional:
        return 60.0;
      case InfusionType.mateDeLeche:
        return 72.0;
      case InfusionType.espresso:
        return 93.0;
      case InfusionType.cafeV60:
        return 92.0;
      case InfusionType.dripFiltrado:
        return 93.0;
      case InfusionType.frenchPress:
        return 94.0;
      case InfusionType.mokaPot:
        return 90.0;
      case InfusionType.cafeInstantaneo:
        return 85.0;
      case InfusionType.coldBrew:
        return 8.0;
      case InfusionType.teSaquito:
        return 88.0;
      case InfusionType.teHebras:
        return 82.0;
    }
  }

  /// Default suggested weight of dry product in grams
  double get defaultWeight {
    switch (this) {
      case InfusionType.mateTradicional:
        return 35.0;
      case InfusionType.mateDeLeche:
        return 30.0;
      case InfusionType.espresso:
        return 18.0;
      case InfusionType.cafeV60:
        return 18.0;
      case InfusionType.dripFiltrado:
        return 20.0;
      case InfusionType.frenchPress:
        return 20.0;
      case InfusionType.mokaPot:
        return 16.0;
      case InfusionType.cafeInstantaneo:
        return 2.5;
      case InfusionType.coldBrew:
        return 50.0;
      case InfusionType.teSaquito:
        return 2.5;
      case InfusionType.teHebras:
        return 4.0;
    }
  }

  /// Default suggested water/liquid volume in ml
  double get defaultVolume {
    switch (this) {
      case InfusionType.mateTradicional:
        return 500.0;
      case InfusionType.mateDeLeche:
        return 400.0;
      case InfusionType.espresso:
        return 38.0;
      case InfusionType.cafeV60:
        return 300.0;
      case InfusionType.dripFiltrado:
        return 320.0;
      case InfusionType.frenchPress:
        return 320.0;
      case InfusionType.mokaPot:
        return 180.0;
      case InfusionType.cafeInstantaneo:
        return 200.0;
      case InfusionType.coldBrew:
        return 600.0;
      case InfusionType.teSaquito:
        return 220.0;
      case InfusionType.teHebras:
        return 280.0;
    }
  }

  List<double> get quickTemperaturePresets {
    switch (this) {
      case InfusionType.mateTradicional:
        return [60.0, 65.0, 70.0, 75.0, 80.0];
      case InfusionType.mateDeLeche:
        return [55.0, 60.0, 65.0, 70.0, 75.0];
      case InfusionType.espresso:
        return [90.0, 92.0, 93.0, 94.0, 96.0];
      case InfusionType.cafeV60:
        return [88.0, 90.0, 92.0, 94.0, 96.0];
      case InfusionType.dripFiltrado:
        return [90.0, 92.0, 94.0, 96.0];
      case InfusionType.frenchPress:
        return [90.0, 92.0, 94.0, 96.0];
      case InfusionType.mokaPot:
        return [85.0, 90.0, 93.0, 95.0];
      case InfusionType.cafeInstantaneo:
        return [75.0, 80.0, 85.0, 90.0, 95.0];
      case InfusionType.coldBrew:
        return [4.0, 8.0, 15.0, 20.0];
      case InfusionType.teSaquito:
        return [75.0, 80.0, 85.0, 90.0, 95.0, 100.0];
      case InfusionType.teHebras:
        return [70.0, 75.0, 80.0, 85.0, 90.0, 95.0];
    }
  }

  static InfusionType fromString(String value) {
    return InfusionType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase() ||
          e.labelFor('es').toLowerCase() == value.toLowerCase() ||
          e.labelFor('en').toLowerCase() == value.toLowerCase(),
      orElse: () => InfusionType.mateTradicional,
    );
  }
}
