import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_log.dart';
import '../../models/infusion_type.dart';
import '../../models/product.dart';
import '../../providers/infusion_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/rating_stars.dart';
import '../widgets/temperature_selector.dart';

class InfusionFormDialog extends StatefulWidget {
  final InfusionLog? existingLog;
  final DateTime? initialDate;
  final Product? preselectedProduct;
  final InfusionCategory? initialCategory;

  const InfusionFormDialog({
    super.key,
    this.existingLog,
    this.initialDate,
    this.preselectedProduct,
    this.initialCategory,
  });

  @override
  State<InfusionFormDialog> createState() => _InfusionFormDialogState();
}

class _InfusionFormDialogState extends State<InfusionFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDateTime;
  late InfusionCategory _selectedCategory;
  late InfusionType _selectedType;
  Product? _selectedProduct;
  late TextEditingController _productNameController;
  late TextEditingController _weightController;
  late TextEditingController _volumeController;
  late TextEditingController _notesController;
  late double _temperature;
  late double _rating;

  @override
  void initState() {
    super.initState();
    final log = widget.existingLog;
    final preProduct = widget.preselectedProduct;

    if (log != null) {
      _selectedDateTime = log.dateTime;
      _selectedCategory = log.category;
      _selectedType = log.type;
      _productNameController = TextEditingController(text: log.productName);
      _weightController = TextEditingController(text: log.weightGrams.toStringAsFixed(1));
      _volumeController = TextEditingController(
        text: log.waterVolumeMl != null ? log.waterVolumeMl!.toStringAsFixed(0) : '',
      );
      _notesController = TextEditingController(text: log.notes);
      _temperature = log.temperatureCelsius;
      _rating = log.rating;
    } else {
      final baseDate = widget.initialDate ?? DateTime.now();
      final now = DateTime.now();
      _selectedDateTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        now.hour,
        now.minute,
      );

      if (preProduct != null) {
        _selectedProduct = preProduct;
        _selectedCategory = preProduct.category;
        switch (preProduct.category) {
          case InfusionCategory.mate:
            _selectedType = InfusionType.mateTradicional;
            break;
          case InfusionCategory.cafe:
            _selectedType = InfusionType.espresso;
            break;
          case InfusionCategory.te:
            _selectedType = InfusionType.teHebras;
            break;
        }
        _productNameController = TextEditingController(text: preProduct.name);
      } else {
        _selectedCategory = widget.initialCategory ?? InfusionCategory.mate;
        switch (_selectedCategory) {
          case InfusionCategory.mate:
            _selectedType = InfusionType.mateTradicional;
            break;
          case InfusionCategory.cafe:
            _selectedType = InfusionType.espresso;
            break;
          case InfusionCategory.te:
            _selectedType = InfusionType.teHebras;
            break;
        }
        _productNameController = TextEditingController();
      }

      _temperature = _selectedType.defaultTemperature;
      _weightController = TextEditingController(
        text: _selectedType.defaultWeight == _selectedType.defaultWeight.roundToDouble()
            ? _selectedType.defaultWeight.toStringAsFixed(0)
            : _selectedType.defaultWeight.toStringAsFixed(1),
      );
      _volumeController = TextEditingController(text: _selectedType.defaultVolume.toStringAsFixed(0));
      _notesController = TextEditingController();
      _rating = 5.0;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _onCategoryChanged(InfusionCategory category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
      _selectedProduct = null;
      switch (category) {
        case InfusionCategory.mate:
          _selectedType = InfusionType.mateTradicional;
          break;
        case InfusionCategory.cafe:
          _selectedType = InfusionType.espresso;
          break;
        case InfusionCategory.te:
          _selectedType = InfusionType.teHebras;
          break;
      }
      _temperature = _selectedType.defaultTemperature;
      _weightController.text = _selectedType.defaultWeight == _selectedType.defaultWeight.roundToDouble()
          ? _selectedType.defaultWeight.toStringAsFixed(0)
          : _selectedType.defaultWeight.toStringAsFixed(1);
      _volumeController.text = _selectedType.defaultVolume.toStringAsFixed(0);
      _productNameController.clear();
    });
  }

  void _onTypeChanged(InfusionType type) {
    setState(() {
      _selectedType = type;
      _temperature = type.defaultTemperature;
      _weightController.text = type.defaultWeight == type.defaultWeight.roundToDouble()
          ? type.defaultWeight.toStringAsFixed(0)
          : type.defaultWeight.toStringAsFixed(1);
      _volumeController.text = type.defaultVolume.toStringAsFixed(0);
    });
  }

  List<InfusionType> get _availableTypes {
    switch (_selectedCategory) {
      case InfusionCategory.mate:
        return [InfusionType.mateTradicional, InfusionType.mateDeLeche];
      case InfusionCategory.cafe:
        return [
          InfusionType.espresso,
          InfusionType.cafeV60,
          InfusionType.dripFiltrado,
          InfusionType.frenchPress,
          InfusionType.mokaPot,
          InfusionType.cafeInstantaneo,
          InfusionType.coldBrew,
        ];
      case InfusionCategory.te:
        return [
          InfusionType.teHebras,
          InfusionType.teSaquito,
        ];
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final weight = double.tryParse(_weightController.text) ?? _selectedType.defaultWeight;
    final volume = double.tryParse(_volumeController.text);
    final finalProductName = _productNameController.text.trim().isEmpty
        ? _selectedType.labelFor(settings.languageCode)
        : _productNameController.text.trim();

    final infusionProvider = Provider.of<InfusionProvider>(context, listen: false);

    if (widget.existingLog != null) {
      final updated = widget.existingLog!.copyWith(
        dateTime: _selectedDateTime,
        category: _selectedCategory,
        type: _selectedType,
        productId: _selectedProduct?.id,
        productName: finalProductName,
        weightGrams: weight,
        waterVolumeMl: volume,
        temperatureCelsius: _temperature,
        rating: _rating,
        notes: _notesController.text.trim(),
      );
      infusionProvider.updateLog(updated);
    } else {
      final newLog = InfusionLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        dateTime: _selectedDateTime,
        category: _selectedCategory,
        type: _selectedType,
        productId: _selectedProduct?.id,
        productName: finalProductName,
        weightGrams: weight,
        waterVolumeMl: volume,
        temperatureCelsius: _temperature,
        rating: _rating,
        notes: _notesController.text.trim(),
      );
      infusionProvider.addLog(newLog);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isEn = settings.languageCode == 'en';
    final productProvider = Provider.of<ProductProvider>(context);
    final availableProducts = productProvider.allProducts
        .where((p) => p.category == _selectedCategory)
        .toList();

    Color accentColor;
    switch (_selectedCategory) {
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

    final dateFormat = DateFormat('EEE, d MMM yyyy', settings.languageCode);
    final timeFormat = DateFormat('HH:mm');

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _selectedCategory.icon,
                          color: accentColor,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.existingLog != null
                              ? (isEn ? 'Edit Infusion' : 'Editar Infusión')
                              : (isEn ? 'New Infusion' : 'Nueva Infusión'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Date and Time Row (Modifiable)
                Text(
                  isEn ? 'Date & Time' : 'Fecha y Hora',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: theme.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.surface1Color),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 18, color: theme.lavenderColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  dateFormat.format(_selectedDateTime),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: _pickTime,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: theme.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.surface1Color),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 18, color: theme.lavenderColor),
                              const SizedBox(width: 8),
                              Text(
                                timeFormat.format(_selectedDateTime),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Category Selector (Yerba Mate / Café / Té)
                Text(
                  isEn ? 'Category' : 'Categoría de Infusión',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        avatar: Icon(
                          Icons.eco_rounded,
                          size: 16,
                          color: _selectedCategory == InfusionCategory.mate
                              ? Colors.black87
                              : theme.greenColor,
                        ),
                        label: Center(
                          child: Text(
                            'Mate',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _selectedCategory == InfusionCategory.mate
                                  ? Colors.black87
                                  : theme.textColor,
                            ),
                          ),
                        ),
                        selected: _selectedCategory == InfusionCategory.mate,
                        selectedColor: theme.greenColor,
                        backgroundColor: theme.surfaceColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onSelected: (selected) {
                          if (selected) _onCategoryChanged(InfusionCategory.mate);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        avatar: Icon(
                          Icons.coffee_rounded,
                          size: 16,
                          color: _selectedCategory == InfusionCategory.cafe
                              ? Colors.black87
                              : theme.peachColor,
                        ),
                        label: Center(
                          child: Text(
                            isEn ? 'Coffee' : 'Café',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _selectedCategory == InfusionCategory.cafe
                                  ? Colors.black87
                                  : theme.textColor,
                            ),
                          ),
                        ),
                        selected: _selectedCategory == InfusionCategory.cafe,
                        selectedColor: theme.peachColor,
                        backgroundColor: theme.surfaceColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onSelected: (selected) {
                          if (selected) _onCategoryChanged(InfusionCategory.cafe);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        avatar: Icon(
                          Icons.emoji_food_beverage_rounded,
                          size: 16,
                          color: _selectedCategory == InfusionCategory.te
                              ? Colors.black87
                              : theme.tealColor,
                        ),
                        label: Center(
                          child: Text(
                            isEn ? 'Tea' : 'Té',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _selectedCategory == InfusionCategory.te
                                  ? Colors.black87
                                  : theme.textColor,
                            ),
                          ),
                        ),
                        selected: _selectedCategory == InfusionCategory.te,
                        selectedColor: theme.tealColor,
                        backgroundColor: theme.surfaceColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onSelected: (selected) {
                          if (selected) _onCategoryChanged(InfusionCategory.te);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Specific Type Chips (Espresso, V60, Drip, French, Moka, Instantáneo, Cold, Saquito, Hebras)
                Text(
                  isEn ? 'Preparation Method' : 'Tipo de Preparación',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTypes.map((type) {
                    final isSelected = _selectedType == type;

                    return FilterChip(
                      avatar: Icon(
                        type.icon,
                        size: 18,
                        color: isSelected ? Colors.black87 : accentColor,
                      ),
                      label: Text(type.labelFor(settings.languageCode)),
                      selected: isSelected,
                      selectedColor: accentColor,
                      backgroundColor: theme.surfaceColor,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.black87 : theme.textColor,
                      ),
                      onSelected: (val) {
                        if (val) _onTypeChanged(type);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Select Product from Catalog or Custom
                Text(
                  isEn ? 'Product / Variety' : 'Producto / Variedad',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                if (availableProducts.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.surface1Color),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Product?>(
                        isExpanded: true,
                        dropdownColor: theme.surfaceColor,
                        value: _selectedProduct,
                        hint: Text(
                            isEn
                                ? 'Select from saved list...'
                                : 'Seleccionar de la lista guardada...',
                          style: TextStyle(color: theme.subtextColor, fontSize: 13),
                        ),
                        items: [
                          DropdownMenuItem<Product?>(
                            value: null,
                            child: Text(
                              isEn
                                  ? '-- Custom input --'
                                  : '-- Entrada personalizada --',
                              style: TextStyle(color: theme.lavenderColor, fontSize: 13),
                            ),
                          ),
                          ...availableProducts.map((prod) {
                            return DropdownMenuItem<Product?>(
                              value: prod,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${prod.name} (${prod.brand})',
                                      style: TextStyle(color: theme.textColor, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '★ ${prod.rating.toStringAsFixed(1)}',
                                    style: TextStyle(color: theme.peachColor, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (prod) {
                          setState(() {
                            _selectedProduct = prod;
                            if (prod != null) {
                              _productNameController.text = prod.name;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                    labelText: isEn ? 'Product name' : 'Nombre del producto',
                    hintText: _selectedCategory == InfusionCategory.mate
                        ? 'Ej: Canarias Serena, Playadito'
                        : _selectedCategory == InfusionCategory.cafe
                            ? 'Ej: Espresso Supremo, Etiopía Yirgacheffe'
                            : 'Ej: Earl Grey Hebras, Té Verde Sencha',
                    prefixIcon: Icon(_selectedCategory.icon, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return isEn
                          ? 'Please enter or select a product'
                          : 'Por favor ingresa o selecciona un producto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Weight and Volume inputs
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                           labelText: isEn ? 'Dry Weight' : 'Peso Seco',
                          hintText: '18',
                          suffixText: settings.weightUnit,
                          prefixIcon: const Icon(Icons.scale_rounded, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requerido';
                          if (double.tryParse(v) == null) return 'Inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _volumeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                           labelText: isEn ? 'Liquid Volume' : 'Agua / Leche',
                          hintText: '250',
                          suffixText: settings.volumeUnit,
                          prefixIcon: const Icon(Icons.water_drop_rounded, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Temperature Selector Component
                TemperatureSelector(
                  temperature: _temperature,
                  infusionType: _selectedType,
                  onTemperatureChanged: (newTemp) {
                    setState(() {
                      _temperature = newTemp;
                    });
                  },
                ),
                const SizedBox(height: 18),

                // Rating Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEn ? 'Session Rating' : 'Calificación de la sesión',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                    RatingStars(
                      rating: _rating,
                      size: 24,
                      showLabel: true,
                      onRatingChanged: (newRating) {
                        setState(() {
                          _rating = newRating;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Session Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: isEn ? 'Tasting notes (optional)' : 'Notas de preparación y cata (opcional)',
                    hintText: 'Ej: Extracción limpia, crema dorada, aroma persistente...',
                    prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: Text(
                        widget.existingLog != null
                          ? (isEn ? 'Save Changes' : 'Guardar Cambios')
                          : (isEn ? 'Log Infusion' : 'Registrar Infusión'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    onPressed: _submitForm,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
