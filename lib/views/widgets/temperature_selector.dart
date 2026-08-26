import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class TemperatureSelector extends StatelessWidget {
  final double temperature;
  final InfusionType infusionType;
  final ValueChanged<double> onTemperatureChanged;

  const TemperatureSelector({
    super.key,
    required this.temperature,
    required this.infusionType,
    required this.onTemperatureChanged,
  });

  Color _getTemperatureColor(BuildContext context, double temp) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    if (temp <= 15) {
      return theme.tealColor; // Cold brew / ice
    } else if (temp <= 75) {
      return theme.greenColor; // Warm / Mate de leche
    } else if (temp <= 85) {
      return theme.yellowColor; // Mate tradicional ideal
    } else {
      return theme.peachColor; // Coffee hot brew
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final tempColor = _getTemperatureColor(context, temperature);
    final presets = infusionType.quickTemperaturePresets;
    final isEn = settings.languageCode == 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.thermostat_rounded,
                  size: 20,
                  color: tempColor,
                ),
                const SizedBox(width: 6),
                Text(
                   isEn ? 'Water / infusion temperature' : 'Temperatura del agua / infusión',
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: tempColor.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tempColor.withAlpha(120), width: 1.5),
              ),
              child: Text(
                '${temperature.toStringAsFixed(temperature.truncateToDouble() == temperature ? 0 : 1)} °C',
                style: TextStyle(
                  color: tempColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Slider with - and + step buttons
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: temperature > 0
                  ? () => onTemperatureChanged((temperature - 1).clamp(0.0, 100.0))
                  : null,
              icon: const Icon(Icons.remove, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: theme.surface1Color,
                foregroundColor: theme.textColor,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: tempColor,
                  thumbColor: tempColor,
                  overlayColor: tempColor.withAlpha(40),
                ),
                child: Slider(
                  value: temperature.clamp(0.0, 100.0),
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  onChanged: (val) => onTemperatureChanged(val),
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: temperature < 100
                  ? () => onTemperatureChanged((temperature + 1).clamp(0.0, 100.0))
                  : null,
              icon: const Icon(Icons.add, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: theme.surface1Color,
                foregroundColor: theme.textColor,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),

        // Quick presets
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: presets.map((preset) {
            final isSelected = (temperature - preset).abs() < 0.5;
            return ChoiceChip(
              label: Text(
                '${preset.toStringAsFixed(0)}°C',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black87 : theme.textColor,
                ),
              ),
              selected: isSelected,
              selectedColor: tempColor,
              backgroundColor: theme.surfaceColor,
              side: BorderSide(
                color: isSelected ? tempColor : theme.surface1Color,
                width: 1,
              ),
              onSelected: (selected) {
                if (selected) {
                  onTemperatureChanged(preset);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
