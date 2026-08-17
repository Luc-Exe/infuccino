import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class RatingStars extends StatelessWidget {
  final double rating; // 0.0 to 5.0
  final double size;
  final ValueChanged<double>? onRatingChanged;
  final bool showLabel;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.onRatingChanged,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isInteractive = onRatingChanged != null;

    final starWidgets = List.generate(5, (index) {
      final starValue = index + 1.0;
      final isFull = rating >= starValue;
      final isHalf = !isFull && rating >= (starValue - 0.5);

      final icon = isFull
          ? Icons.star_rounded
          : isHalf
              ? Icons.star_half_rounded
              : Icons.star_outline_rounded;

      final color = (isFull || isHalf)
          ? theme.peachColor
          : theme.subtextColor.withAlpha(80);

      final starIcon = Icon(icon, size: size, color: color);

      if (!isInteractive) {
        return starIcon;
      }

      return GestureDetector(
        onTap: () {
          // If tapped on already selected whole rating, allow toggling half
          if (rating == starValue) {
            onRatingChanged!(starValue - 0.5);
          } else {
            onRatingChanged!(starValue);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: starIcon,
        ),
      );
    });

    if (!showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: starWidgets,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...starWidgets,
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.85,
          ),
        ),
      ],
    );
  }
}
