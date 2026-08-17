import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/catppuccin_colors.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeType _currentThemeType = AppThemeType.mocha;

  AppThemeType get currentThemeType => _currentThemeType;
  bool get isDark => _currentThemeType != AppThemeType.latte;

  ThemeData get currentTheme {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return AppTheme.mochaDarkTheme;
      case AppThemeType.latte:
        return AppTheme.latteLightTheme;
      case AppThemeType.cyberpunk:
        return AppTheme.cyberpunkTheme;
      case AppThemeType.cafe:
        return AppTheme.cafeTheme;
    }
  }

  Color get baseColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaBase;
      case AppThemeType.latte:
        return CatppuccinColors.latteBase;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberBase;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeBase;
    }
  }

  Color get surfaceColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaSurface0;
      case AppThemeType.latte:
        return CatppuccinColors.latteSurface0;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberSurface0;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeSurface0;
    }
  }

  Color get surface1Color {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaSurface1;
      case AppThemeType.latte:
        return CatppuccinColors.latteSurface1;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberSurface1;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeSurface1;
    }
  }

  Color get textColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaText;
      case AppThemeType.latte:
        return CatppuccinColors.latteText;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberText;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeText;
    }
  }

  Color get subtextColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaSubtext0;
      case AppThemeType.latte:
        return CatppuccinColors.latteSubtext0;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberSubtext;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeSubtext;
    }
  }

  Color get lavenderColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaLavender;
      case AppThemeType.latte:
        return CatppuccinColors.latteLavender;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberNeonCyan;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeCaramel;
    }
  }

  Color get peachColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaPeach;
      case AppThemeType.latte:
        return CatppuccinColors.lattePeach;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberNeonYellow;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeAmber;
    }
  }

  Color get greenColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaGreen;
      case AppThemeType.latte:
        return CatppuccinColors.latteGreen;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberNeonGreen;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeHerbGreen;
    }
  }

  Color get tealColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaTeal;
      case AppThemeType.latte:
        return CatppuccinColors.latteTeal;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberNeonCyan;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeAmber;
    }
  }

  Color get redColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaRed;
      case AppThemeType.latte:
        return CatppuccinColors.latteRed;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberNeonRed;
      case AppThemeType.cafe:
        return const Color(0xFFE65100);
    }
  }

  Color get mantleColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaMantle;
      case AppThemeType.latte:
        return CatppuccinColors.latteMantle;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberMantle;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeMantle;
    }
  }

  Color get yellowColor {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        return CatppuccinColors.mochaYellow;
      case AppThemeType.latte:
        return CatppuccinColors.latteYellow;
      case AppThemeType.cyberpunk:
        return CatppuccinColors.cyberNeonYellow;
      case AppThemeType.cafe:
        return CatppuccinColors.cafeAmber;
    }
  }

  void setThemeType(AppThemeType themeType) {
    if (_currentThemeType != themeType) {
      _currentThemeType = themeType;
      notifyListeners();
    }
  }

  void toggleTheme() {
    switch (_currentThemeType) {
      case AppThemeType.mocha:
        _currentThemeType = AppThemeType.latte;
        break;
      case AppThemeType.latte:
        _currentThemeType = AppThemeType.cyberpunk;
        break;
      case AppThemeType.cyberpunk:
        _currentThemeType = AppThemeType.cafe;
        break;
      case AppThemeType.cafe:
        _currentThemeType = AppThemeType.mocha;
        break;
    }
    notifyListeners();
  }
}
