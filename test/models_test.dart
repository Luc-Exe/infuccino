import 'package:flutter_test/flutter_test.dart';
import 'package:agenda_de_infusiones/models/infusion_type.dart';
import 'package:agenda_de_infusiones/models/product.dart';
import 'package:agenda_de_infusiones/models/infusion_log.dart';
import 'package:agenda_de_infusiones/providers/settings_provider.dart';

void main() {
  group('InfusionType & Category Tests', () {
    test('Mate types belong to mate category', () {
      expect(InfusionType.mateTradicional.category, InfusionCategory.mate);
      expect(InfusionType.mateDeLeche.category, InfusionCategory.mate);
      expect(InfusionType.mateTradicional.defaultTemperature, 78.0);
    });

    test('Coffee types belong to coffee category and have appropriate defaults', () {
      expect(InfusionType.espresso.category, InfusionCategory.cafe);
      expect(InfusionType.cafeV60.category, InfusionCategory.cafe);
      expect(InfusionType.dripFiltrado.category, InfusionCategory.cafe);
      expect(InfusionType.frenchPress.category, InfusionCategory.cafe);
      expect(InfusionType.mokaPot.category, InfusionCategory.cafe);
      expect(InfusionType.cafeInstantaneo.category, InfusionCategory.cafe);
      expect(InfusionType.coldBrew.category, InfusionCategory.cafe);

      expect(InfusionType.espresso.defaultTemperature, 93.0);
      expect(InfusionType.cafeInstantaneo.defaultWeight, 2.5);
      expect(InfusionType.coldBrew.defaultTemperature, 8.0);
    });

    test('Tea types belong to tea category', () {
      expect(InfusionType.teSaquito.category, InfusionCategory.te);
      expect(InfusionType.teHebras.category, InfusionCategory.te);
      expect(InfusionType.teSaquito.defaultWeight, 2.5);
      expect(InfusionType.teHebras.defaultWeight, 4.0);
    });

    test('FromString parsing', () {
      expect(InfusionCategory.fromString('mate'), InfusionCategory.mate);
      expect(InfusionCategory.fromString('cafe'), InfusionCategory.cafe);
      expect(InfusionCategory.fromString('te'), InfusionCategory.te);
      expect(InfusionType.fromString('espresso'), InfusionType.espresso);
      expect(InfusionType.fromString('cafeInstantaneo'), InfusionType.cafeInstantaneo);
      expect(InfusionType.fromString('teHebras'), InfusionType.teHebras);
    });
  });

  group('SettingsProvider Unit & Formatting Tests', () {
    test('Metric and Imperial formatting conversions', () {
      final settings = SettingsProvider();

      expect(settings.isMetric, true);
      expect(settings.formatWeight(35.0), '35 g');
      expect(settings.formatTemperature(78.0), '78 °C');
      expect(settings.formatVolume(500.0), '500 ml');

      settings.setUnitSystem(UnitSystem.imperial);
      expect(settings.isMetric, false);
      expect(settings.formatWeight(35.0), '1.2 oz');
      expect(settings.formatTemperature(78.0), '172 °F');
    });

    test('About text attribution', () {
      expect(SettingsProvider.aboutText, 'Hecho con amor ❤️ por Luc-Exe');
    });
  });

  group('Product Serialization Tests', () {
    test('Product toMap and fromMap roundtrip for Tea', () {
      final product = Product(
        id: 'p_te_1',
        name: 'Earl Grey Imperial',
        brand: 'Twinings',
        category: InfusionCategory.te,
        rating: 4.9,
        origin: 'Sri Lanka',
        tastingNotes: ['Bergamota', 'Cítrico limón', 'Floral'],
        description: 'Té negro aromático con bergamota',
      );

      final map = product.toMap();
      final restored = Product.fromMap(map);

      expect(restored.id, product.id);
      expect(restored.name, product.name);
      expect(restored.category, InfusionCategory.te);
      expect(restored.rating, product.rating);
    });
  });

  group('InfusionLog Serialization Tests', () {
    test('InfusionLog toMap and fromMap roundtrip for Espresso', () {
      final now = DateTime(2026, 8, 17, 18, 0);
      final log = InfusionLog(
        id: 'l_esp',
        dateTime: now,
        category: InfusionCategory.cafe,
        type: InfusionType.espresso,
        productName: 'Espresso Intenso',
        weightGrams: 18.0,
        waterVolumeMl: 38.0,
        temperatureCelsius: 93.0,
        rating: 5.0,
        notes: 'Crema espesa y cuerpo sedoso',
      );

      final map = log.toMap();
      final restored = InfusionLog.fromMap(map);

      expect(restored.id, log.id);
      expect(restored.type, InfusionType.espresso);
      expect(restored.weightGrams, 18.0);
      expect(restored.temperatureCelsius, 93.0);
    });
  });
}
