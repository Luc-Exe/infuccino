import 'infusion_type.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final InfusionCategory category;
  final String? imagePath;
  final double rating; // 0.0 to 5.0
  final String origin;
  final List<String> tastingNotes;
  final String description;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.imagePath,
    required this.rating,
    this.origin = '',
    this.tastingNotes = const [],
    this.description = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    InfusionCategory? category,
    String? imagePath,
    double? rating,
    String? origin,
    List<String>? tastingNotes,
    String? description,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      origin: origin ?? this.origin,
      tastingNotes: tastingNotes ?? this.tastingNotes,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category.name,
      'imagePath': imagePath,
      'rating': rating,
      'origin': origin,
      'tastingNotes': tastingNotes.join(','),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    final rawNotes = map['tastingNotes'] as String? ?? '';
    final notesList = rawNotes.isNotEmpty
        ? rawNotes.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : <String>[];

    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String? ?? '',
      category: InfusionCategory.fromString(map['category'] as String? ?? 'mate'),
      imagePath: map['imagePath'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      origin: map['origin'] as String? ?? '',
      tastingNotes: notesList,
      description: map['description'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
