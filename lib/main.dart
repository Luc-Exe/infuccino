import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/infusion_provider.dart';
import 'providers/product_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/theme_provider.dart';
import 'views/home_navigation_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final productProvider = ProductProvider();
  final infusionProvider = InfusionProvider();
  final settingsProvider = SettingsProvider();

  // Load initial persistent data from database
  await productProvider.loadProducts();
  await infusionProvider.loadLogs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: productProvider),
        ChangeNotifierProvider.value(value: infusionProvider),
      ],
      child: const InfuccinoApp(),
    ),
  );
}

class InfuccinoApp extends StatelessWidget {
  const InfuccinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Infuccino',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('es', 'AR'),
        Locale('es', ''),
        Locale('en', 'US'),
        Locale('en', ''),
      ],
      locale: settingsProvider.locale,
      home: const HomeNavigationView(),
    );
  }
}
