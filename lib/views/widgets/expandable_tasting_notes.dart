import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../providers/theme_provider.dart';

class ExpandableTastingNotes extends StatefulWidget {
  final InfusionCategory category;
  final List<String> selectedNotes;
  final ValueChanged<List<String>> onNotesChanged;

  const ExpandableTastingNotes({
    super.key,
    required this.category,
    required this.selectedNotes,
    required this.onNotesChanged,
  });

  @override
  State<ExpandableTastingNotes> createState() => _ExpandableTastingNotesState();
}

class _ExpandableTastingNotesState extends State<ExpandableTastingNotes> {
  bool _isExpanded = false;
  final TextEditingController _customNoteController = TextEditingController();

  static const Map<String, List<String>> _tastingNoteGroups = {
    '🌿 Herbales & Frescos': [
      'Suave',
      'Intenso',
      'Herbal',
      'Menta',
      'Manzanilla',
      'Toronjil',
      'Pasto fresco',
      'Eucalipto',
      'Cedrón',
      'Lemongrass',
    ],
    '🌸 Florales & Aromáticos': [
      'Jazmín',
      'Lavanda',
      'Rosas',
      'Azahar',
      'Floral',
      'Bergamota',
      'Flor de saúco',
    ],
    '🍓 Frutales & Cítricos': [
      'Cítrico limón',
      'Frutos rojos',
      'Melocotón',
      'Manzana',
      'Naranja',
      'Arándanos',
      'Frutas tropicales',
      'Cerezo',
    ],
    '🍫 Dulces & Tostados': [
      'Chocolate amargo',
      'Chocolate con leche',
      'Caramelo',
      'Avellana',
      'Vainilla',
      'Miel',
      'Azúcar moreno',
      'Tostado',
      'Nuez',
    ],
    '🪵 Maderas & Especiados': [
      'Ahumado',
      'Barbacuá',
      'Con palo',
      'Despalada',
      'Canela',
      'Jengibre',
      'Cardamomo',
      'Clavo de olor',
      'Madera',
      'Pimienta dulce',
    ],
  };

  @override
  void dispose() {
    _customNoteController.dispose();
    super.dispose();
  }

  void _toggleNote(String note) {
    final updated = List<String>.from(widget.selectedNotes);
    if (updated.contains(note)) {
      updated.remove(note);
    } else {
      updated.add(note);
    }
    widget.onNotesChanged(updated);
  }

  void _addCustomNote() {
    final text = _customNoteController.text.trim();
    if (text.isNotEmpty && !widget.selectedNotes.contains(text)) {
      final updated = List<String>.from(widget.selectedNotes)..add(text);
      widget.onNotesChanged(updated);
      _customNoteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    Color accentColor;
    switch (widget.category) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Expandable Notch
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.surface1Color),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.palette_rounded, size: 18, color: accentColor),
                    const SizedBox(width: 8),
                    Text(
                      'Perfil y Notas de Cata',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                    if (widget.selectedNotes.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(theme.isDark ? 45 : 30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${widget.selectedNotes.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Small notch / chevron indicator
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.surface1Color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: theme.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Selected Chips Preview when collapsed or expanded
        if (widget.selectedNotes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.selectedNotes.map((note) {
              return Chip(
                label: Text(note),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => _toggleNote(note),
                backgroundColor: accentColor.withAlpha(theme.isDark ? 40 : 25),
                side: BorderSide(color: accentColor.withAlpha(120)),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              );
            }).toList(),
          ),
        ],

        // Expanded Rich Catalog of Notes
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.mantleColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.surface1Color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._tastingNoteGroups.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: theme.subtextColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: entry.value.map((note) {
                            final isSelected = widget.selectedNotes.contains(note);
                            return FilterChip(
                              label: Text(note),
                              selected: isSelected,
                              selectedColor: accentColor,
                              backgroundColor: theme.surfaceColor,
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.black87 : theme.textColor,
                              ),
                              onSelected: (_) => _toggleNote(note),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 16),
                // Custom note entry
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customNoteController,
                        decoration: const InputDecoration(
                          hintText: 'Agregar otra nota...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onSubmitted: (_) => _addCustomNote(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.black87,
                      ),
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: _addCustomNote,
                    ),
                  ],
                ),
              ],
            ),
          ),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}
