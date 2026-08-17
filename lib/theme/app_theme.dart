import 'package:flutter/material.dart';
import 'catppuccin_colors.dart';

enum AppThemeType {
  mocha,
  latte,
  cyberpunk,
  cafe;

  String get label {
    switch (this) {
      case AppThemeType.mocha:
        return 'Catppuccin Mocha';
      case AppThemeType.latte:
        return 'Catppuccin Latte';
      case AppThemeType.cyberpunk:
        return 'Cyberpunk Neon';
      case AppThemeType.cafe:
        return 'Café Espresso';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeType.mocha:
        return Icons.nightlight_round;
      case AppThemeType.latte:
        return Icons.wb_sunny_rounded;
      case AppThemeType.cyberpunk:
        return Icons.bolt_rounded;
      case AppThemeType.cafe:
        return Icons.coffee_rounded;
    }
  }
}

class AppTheme {
  // 1. Catppuccin Mocha (Dark)
  static ThemeData get mochaDarkTheme {
    final colorScheme = ColorScheme.dark(
      surface: CatppuccinColors.mochaSurface0,
      primary: CatppuccinColors.mochaLavender,
      onPrimary: CatppuccinColors.mochaCrust,
      secondary: CatppuccinColors.mochaPeach,
      onSecondary: CatppuccinColors.mochaCrust,
      tertiary: CatppuccinColors.mochaGreen,
      onTertiary: CatppuccinColors.mochaCrust,
      error: CatppuccinColors.mochaRed,
      onError: CatppuccinColors.mochaCrust,
      onSurface: CatppuccinColors.mochaText,
      outline: CatppuccinColors.mochaSurface2,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBg: CatppuccinColors.mochaBase,
      mantle: CatppuccinColors.mochaMantle,
      surface: CatppuccinColors.mochaSurface0,
      surface1: CatppuccinColors.mochaSurface1,
      text: CatppuccinColors.mochaText,
      subtext: CatppuccinColors.mochaSubtext0,
      primary: CatppuccinColors.mochaLavender,
      accent: CatppuccinColors.mochaPeach,
      isDark: true,
    );
  }

  // 2. Catppuccin Latte (Light)
  static ThemeData get latteLightTheme {
    final colorScheme = ColorScheme.light(
      surface: CatppuccinColors.latteSurface0,
      primary: CatppuccinColors.latteLavender,
      onPrimary: CatppuccinColors.latteBase,
      secondary: CatppuccinColors.lattePeach,
      onSecondary: CatppuccinColors.latteBase,
      tertiary: CatppuccinColors.latteGreen,
      onTertiary: CatppuccinColors.latteBase,
      error: CatppuccinColors.latteRed,
      onError: CatppuccinColors.latteBase,
      onSurface: CatppuccinColors.latteText,
      outline: CatppuccinColors.latteSurface2,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBg: CatppuccinColors.latteBase,
      mantle: CatppuccinColors.latteMantle,
      surface: CatppuccinColors.latteSurface0,
      surface1: CatppuccinColors.latteSurface1,
      text: CatppuccinColors.latteText,
      subtext: CatppuccinColors.latteSubtext0,
      primary: CatppuccinColors.latteLavender,
      accent: CatppuccinColors.lattePeach,
      isDark: false,
    );
  }

  // 3. Cyberpunk (Dark Neon)
  static ThemeData get cyberpunkTheme {
    final colorScheme = const ColorScheme.dark(
      surface: CatppuccinColors.cyberSurface0,
      primary: CatppuccinColors.cyberNeonCyan,
      onPrimary: Colors.black,
      secondary: CatppuccinColors.cyberNeonYellow,
      onSecondary: Colors.black,
      tertiary: CatppuccinColors.cyberNeonRed,
      onTertiary: Colors.white,
      error: CatppuccinColors.cyberNeonRed,
      onError: Colors.white,
      onSurface: CatppuccinColors.cyberText,
      outline: CatppuccinColors.cyberSurface2,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBg: CatppuccinColors.cyberBase,
      mantle: CatppuccinColors.cyberMantle,
      surface: CatppuccinColors.cyberSurface0,
      surface1: CatppuccinColors.cyberSurface1,
      text: CatppuccinColors.cyberText,
      subtext: CatppuccinColors.cyberSubtext,
      primary: CatppuccinColors.cyberNeonCyan,
      accent: CatppuccinColors.cyberNeonYellow,
      isDark: true,
    );
  }

  // 4. Café (Dark Warm Espresso)
  static ThemeData get cafeTheme {
    final colorScheme = const ColorScheme.dark(
      surface: CatppuccinColors.cafeSurface0,
      primary: CatppuccinColors.cafeCaramel,
      onPrimary: Colors.black,
      secondary: CatppuccinColors.cafeAmber,
      onSecondary: Colors.black,
      tertiary: CatppuccinColors.cafeHerbGreen,
      onTertiary: Colors.black,
      error: Color(0xFFE65100),
      onError: Colors.white,
      onSurface: CatppuccinColors.cafeText,
      outline: CatppuccinColors.cafeSurface2,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBg: CatppuccinColors.cafeBase,
      mantle: CatppuccinColors.cafeMantle,
      surface: CatppuccinColors.cafeSurface0,
      surface1: CatppuccinColors.cafeSurface1,
      text: CatppuccinColors.cafeText,
      subtext: CatppuccinColors.cafeSubtext,
      primary: CatppuccinColors.cafeCaramel,
      accent: CatppuccinColors.cafeAmber,
      isDark: true,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBg,
    required Color mantle,
    required Color surface,
    required Color surface1,
    required Color text,
    required Color subtext,
    required Color primary,
    required Color accent,
    required bool isDark,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: colorScheme,
      canvasColor: mantle,
      cardColor: surface,
      dividerColor: surface1,
      appBarTheme: AppBarTheme(
        backgroundColor: mantle,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: text,
          letterSpacing: 0.2,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: mantle,
        indicatorColor: surface1,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: subtext,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary);
          }
          return IconThemeData(color: subtext);
        }),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: surface1, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: subtext.withAlpha(140)),
        labelStyle: TextStyle(color: subtext),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: surface1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: surface1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        disabledColor: mantle,
        selectedColor: surface1,
        secondarySelectedColor: primary,
        labelStyle: TextStyle(color: text, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: surface1),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: isDark ? Colors.black87 : Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: surface1),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: surface1,
        thumbColor: accent,
        overlayColor: accent.withAlpha(40),
        trackHeight: 6,
      ),
    );
  }
}
