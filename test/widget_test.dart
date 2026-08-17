import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:agenda_de_infusiones/main.dart';
import 'package:agenda_de_infusiones/providers/infusion_provider.dart';
import 'package:agenda_de_infusiones/providers/product_provider.dart';
import 'package:agenda_de_infusiones/providers/settings_provider.dart';
import 'package:agenda_de_infusiones/providers/theme_provider.dart';

void main() {
  testWidgets('App renders Infuccino with SettingsProvider and 4 navigation tabs', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    final settingsProvider = SettingsProvider();
    final productProvider = ProductProvider();
    final infusionProvider = InfusionProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: productProvider),
          ChangeNotifierProvider.value(value: infusionProvider),
        ],
        child: const InfuccinoApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify presence of 4 navigation tabs
    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Agenda'), findsWidgets);
    expect(find.text('Lista'), findsWidgets);
    expect(find.text('Estadísticas'), findsWidgets);

    // Verify AppBar brand title
    expect(find.text('Infuccino'), findsOneWidget);
  });
}
