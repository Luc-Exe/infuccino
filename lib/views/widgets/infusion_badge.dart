import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class InfusionBadge extends StatelessWidget {
  final InfusionType type;
  final bool showCategory;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const InfusionBadge({
    super.key,
    required this.type,
    this.showCategory = false,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    Color badgeColor;
    switch (type.category) {
      case InfusionCategory.mate:
        badgeColor = theme.greenColor;
        break;
      case InfusionCategory.cafe:
        badgeColor = theme.peachColor;
        break;
      case InfusionCategory.te:
        badgeColor = theme.tealColor;
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(theme.isDark ? 35 : 25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withAlpha(theme.isDark ? 90 : 70),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type.icon,
            size: fontSize + 3,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            type.labelFor(settings.languageCode),
            style: TextStyle(
              color: badgeColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
