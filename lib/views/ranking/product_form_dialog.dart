import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/infusion_type.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/image_service.dart';
import '../widgets/expandable_tasting_notes.dart';
import '../widgets/rating_stars.dart';

class ProductFormDialog extends StatefulWidget {
  final Product? existingProduct;
  final InfusionCategory? initialCategory;

  const ProductFormDialog({
    super.key,
    this.existingProduct,
    this.initialCategory,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final ImageService _imageService = ImageService();

  late InfusionCategory _category;
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _originController;
  late TextEditingController _descriptionController;

  String? _imagePath;
  late double _rating;
  late List<String> _selectedTastingNotes;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    if (p != null) {
      _category = p.category;
      _nameController = TextEditingController(text: p.name);
      _brandController = TextEditingController(text: p.brand);
      _originController = TextEditingController(text: p.origin);
      _descriptionController = TextEditingController(text: p.description);
      _imagePath = p.imagePath;
      _rating = p.rating;
      _selectedTastingNotes = List<String>.from(p.tastingNotes);
    } else {
      _category = widget.initialCategory ?? InfusionCategory.mate;
      _nameController = TextEditingController();
      _brandController = TextEditingController();
      _originController = TextEditingController();
      _descriptionController = TextEditingController();
      _imagePath = null;
      _rating = 4.5;
      _selectedTastingNotes = [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _originController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final path = await _imageService.pickAndSaveImage(source);
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  void _showImageSourcePicker() {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isEn = settings.languageCode == 'en';
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEn ? 'Select Product Photo' : 'Seleccionar Foto del Producto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.camera_alt_rounded, color: theme.lavenderColor),
                title: Text(isEn ? 'Take Photo with Camera' : 'Tomar Foto con la Cámara', style: TextStyle(color: theme.textColor)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library_rounded, color: theme.peachColor),
                title: Text(isEn ? 'Choose from Gallery' : 'Elegir de la Galería', style: TextStyle(color: theme.textColor)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_imagePath != null)
                ListTile(
                  leading: Icon(Icons.delete_outline_rounded, color: theme.redColor),
                  title: Text(isEn ? 'Remove Current Photo' : 'Quitar Foto Actual', style: TextStyle(color: theme.redColor)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _imagePath = null;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    if (widget.existingProduct != null) {
      final updated = widget.existingProduct!.copyWith(
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        category: _category,
        imagePath: _imagePath,
        rating: _rating,
        origin: _originController.text.trim(),
        tastingNotes: _selectedTastingNotes,
        description: _descriptionController.text.trim(),
      );
      productProvider.updateProduct(updated);
    } else {
      final newProduct = Product(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        category: _category,
        imagePath: _imagePath,
        rating: _rating,
        origin: _originController.text.trim(),
        tastingNotes: _selectedTastingNotes,
        description: _descriptionController.text.trim(),
      );
      productProvider.addProduct(newProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isEn = settings.languageCode == 'en';

    Color accentColor;
    switch (_category) {
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
                          _category.icon,
                          color: accentColor,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.existingProduct != null ? (isEn ? 'Edit List Item' : 'Editar en Lista') : (isEn ? 'Add to List' : 'Añadir a la Lista'),
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

                // Photo Picker Section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showImageSourcePicker,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: theme.surface1Color,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: accentColor, width: 2),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _imagePath != null && File(_imagePath!).existsSync()
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(File(_imagePath!), fit: BoxFit.cover),
                                    Container(
                                      color: Colors.black38,
                                      child: const Center(
                                        child: Icon(Icons.camera_alt, color: Colors.white70, size: 28),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_rounded, size: 32, color: accentColor),
                                    const SizedBox(height: 6),
                                    Text(
                                      isEn ? 'Add Photo' : 'Añadir Foto',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: theme.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isEn ? 'Camera or local gallery' : 'Cámara o Galería local',
                        style: TextStyle(fontSize: 11, color: theme.subtextColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Category Selection (Mate vs Café vs Té)
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        avatar: Icon(
                          Icons.eco_rounded,
                          size: 16,
                          color: _category == InfusionCategory.mate ? Colors.black87 : theme.greenColor,
                        ),
                        label: Center(
                          child: Text(
                            isEn ? 'Mate' : 'Mate',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _category == InfusionCategory.mate ? Colors.black87 : theme.textColor,
                            ),
                          ),
                        ),
                        selected: _category == InfusionCategory.mate,
                        selectedColor: theme.greenColor,
                        backgroundColor: theme.surfaceColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _category = InfusionCategory.mate;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        avatar: Icon(
                          Icons.coffee_rounded,
                          size: 16,
                          color: _category == InfusionCategory.cafe ? Colors.black87 : theme.peachColor,
                        ),
                        label: Center(
                          child: Text(
                            isEn ? 'Coffee' : 'Café',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _category == InfusionCategory.cafe ? Colors.black87 : theme.textColor,
                            ),
                          ),
                        ),
                        selected: _category == InfusionCategory.cafe,
                        selectedColor: theme.peachColor,
                        backgroundColor: theme.surfaceColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _category = InfusionCategory.cafe;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        avatar: Icon(
                          Icons.emoji_food_beverage_rounded,
                          size: 16,
                          color: _category == InfusionCategory.te ? Colors.black87 : theme.tealColor,
                        ),
                        label: Center(
                          child: Text(
                            isEn ? 'Tea' : 'Té',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _category == InfusionCategory.te ? Colors.black87 : theme.textColor,
                            ),
                          ),
                        ),
                        selected: _category == InfusionCategory.te,
                        selectedColor: theme.tealColor,
                        backgroundColor: theme.surfaceColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _category = InfusionCategory.te;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name & Brand
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: _category == InfusionCategory.mate
                        ? (isEn ? 'Mate name' : 'Nombre de la Yerba')
                        : _category == InfusionCategory.cafe
                            ? (isEn ? 'Coffee name / varietal' : 'Nombre del Café / Varietal')
                            : (isEn ? 'Tea name / variety' : 'Nombre del Té / Variedad'),
                    hintText: _category == InfusionCategory.mate
                        ? (isEn ? 'Ex: Canarias Serena' : 'Ej: Canarias Serena')
                        : _category == InfusionCategory.cafe
                            ? (isEn ? 'Ex: Geisha Los Pozos' : 'Ej: Geisha Los Pozos')
                            : (isEn ? 'Ex: Earl Grey Imperial' : 'Ej: Earl Grey Imperial'),
                    prefixIcon: const Icon(Icons.label_rounded, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return isEn ? 'Name is required' : 'El nombre es obligatorio';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _brandController,
                        decoration: InputDecoration(
                          labelText: isEn ? 'Brand / Producer' : 'Marca / Productor',
                          hintText: isEn ? 'Ex: Playadito, Twinings' : 'Ej: Playadito, Twinings',
                          prefixIcon: Icon(Icons.business_rounded, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _originController,
                        decoration: InputDecoration(
                          labelText: isEn ? 'Origin / Region' : 'Origen / Región',
                          hintText: isEn ? 'Ex: Misiones, Sri Lanka' : 'Ej: Misiones, Sri Lanka',
                          prefixIcon: Icon(Icons.public_rounded, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Rating (Ranking Score)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'List Ranking Score' : 'Puntuación en la Lista',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textColor,
                          ),
                        ),
                        Text(
                          isEn ? 'Defines its ranking position' : 'Define su posición de ranking',
                          style: TextStyle(fontSize: 11, color: theme.subtextColor),
                        ),
                      ],
                    ),
                    RatingStars(
                      rating: _rating,
                      size: 26,
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

                // Expandable Tasting Notes Component (with notch)
                ExpandableTastingNotes(
                  category: _category,
                  selectedNotes: _selectedTastingNotes,
                  onNotesChanged: (notes) {
                    setState(() {
                      _selectedTastingNotes = notes;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Description / Personal review
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: isEn ? 'Description / Personal review' : 'Descripción / Reseña Personal',
                    hintText: isEn
                        ? 'Describe the aroma, processing, body, aging, or notes...'
                        : 'Describe el aroma, secado, cuerpo, estacionamiento o notas...',
                    prefixIcon: Icon(Icons.notes_rounded, size: 20),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: Text(
                      widget.existingProduct != null ? (isEn ? 'Save Changes' : 'Guardar Cambios') : (isEn ? 'Save to List' : 'Guardar en la Lista'),
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
