import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../providers/theme_provider.dart';

class ProductImageAvatar extends StatelessWidget {
  final String? imagePath;
  final InfusionCategory category;
  final double size;
  final double borderRadius;

  const ProductImageAvatar({
    super.key,
    this.imagePath,
    required this.category,
    this.size = 54,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    Color accentColor;
    switch (category) {
      case InfusionCategory.mate:
        accentColor = theme.greenColor;
        break;
      case InfusionCategory.cafe:
        accentColor = theme.peachColor;
        break;
      case InfusionCategory.te:
        accentColor = theme.tealColor;
        break;
    }

    Widget content;
    if (imagePath != null && File(imagePath!).existsSync()) {
      content = Image.file(
        File(imagePath!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackIcon(theme, accentColor),
      );
    } else {
      content = _fallbackIcon(theme, accentColor);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.surface1Color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: accentColor.withAlpha(theme.isDark ? 80 : 50),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }

  Widget _fallbackIcon(ThemeProvider theme, Color accentColor) {
    IconData icon;
    switch (category) {
      case InfusionCategory.mate:
        icon = Icons.eco_rounded;
        break;
      case InfusionCategory.cafe:
        icon = Icons.coffee_rounded;
        break;
      case InfusionCategory.te:
        icon = Icons.emoji_food_beverage_rounded;
        break;
    }

    return Container(
      color: accentColor.withAlpha(theme.isDark ? 30 : 20),
      child: Center(
        child: Icon(
          icon,
          size: size * 0.5,
          color: accentColor,
        ),
      ),
    );
  }
}
