import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../models/product.dart';
import '../../providers/infusion_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/theme_provider.dart';
import '../calendar/infusion_form_dialog.dart';
import '../widgets/catppuccin_card.dart';
import '../widgets/infusion_badge.dart';
import '../widgets/rating_stars.dart';
import 'product_form_dialog.dart';

class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  void _openEditProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ProductFormDialog(existingProduct: product),
    );
  }

  void _openBrewSession(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => InfusionFormDialog(
        initialDate: DateTime.now(),
        preselectedProduct: product,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar producto?', style: TextStyle(color: theme.textColor)),
        content: Text(
          '¿Estás seguro de eliminar "${product.name}" de la lista?',
          style: TextStyle(color: theme.subtextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar', style: TextStyle(color: theme.subtextColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: theme.redColor),
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).deleteProduct(product.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    Color accentColor;
    switch (product.category) {
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

    final infusionProvider = Provider.of<InfusionProvider>(context);
    final productLogs = infusionProvider.allLogs
        .where((l) => l.productId == product.id || l.productName.toLowerCase() == product.name.toLowerCase())
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            tooltip: 'Editar producto',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _openEditProduct(context),
          ),
          IconButton(
            tooltip: 'Eliminar producto',
            icon: Icon(Icons.delete_outline_rounded, color: theme.redColor),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.black87,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: Icon(product.category.icon),
            label: Text(
              'Preparar Infusión con ${product.name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onPressed: () => _openBrewSession(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Photo or Banner
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: theme.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.surface1Color),
              ),
              clipBehavior: Clip.antiAlias,
              child: product.imagePath != null && File(product.imagePath!).existsSync()
                  ? Image.file(
                      File(product.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            product.category.icon,
                            size: 72,
                            color: accentColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.category.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.subtextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Product Header & Rating
            CatppuccinCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                            ),
                            if (product.brand.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                product.brand,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.subtextColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(theme.isDark ? 40 : 25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accentColor.withAlpha(120), width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, size: 20, color: theme.peachColor),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RatingStars(rating: product.rating, size: 22),
                  if (product.origin.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 16, color: theme.lavenderColor),
                        const SizedBox(width: 6),
                        Text(
                          'Origen: ${product.origin}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tasting Notes Section
            if (product.tastingNotes.isNotEmpty) ...[
              CatppuccinCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perfil de Sabor & Notas de Cata',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.tastingNotes.map((note) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: accentColor.withAlpha(theme.isDark ? 30 : 20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: accentColor.withAlpha(80)),
                          ),
                          child: Text(
                            note,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Description / Review
            if (product.description.isNotEmpty) ...[
              CatppuccinCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reseña & Detalles',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // History of Sessions with this Product
            CatppuccinCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Historial de Preparaciones',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      Text(
                        '${productLogs.length} sesiones',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.subtextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (productLogs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Aún no has registrado sesiones con este producto en el calendario.',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.subtextColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productLogs.length,
                      separatorBuilder: (ctx, index) => Divider(color: theme.surface1Color, height: 16),
                      itemBuilder: (context, idx) {
                        final log = productLogs[idx];
                        return Row(
                          children: [
                            InfusionBadge(type: log.type, fontSize: 10),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd MMM yyyy, HH:mm', 'es').format(log.dateTime),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textColor,
                                    ),
                                  ),
                                  Text(
                                    '${log.weightGrams.toStringAsFixed(1)}g • ${log.temperatureCelsius.toStringAsFixed(0)}°C',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.subtextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RatingStars(rating: log.rating, size: 14),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
