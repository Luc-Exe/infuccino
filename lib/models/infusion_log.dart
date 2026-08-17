import 'infusion_type.dart';

class InfusionLog {
  final String id;
  final DateTime dateTime; // Modifiable date & time
  final InfusionCategory category;
  final InfusionType type;
  final String? productId;
  final String productName;
  final double weightGrams; // Weight in grams
  final double? waterVolumeMl; // Volume in ml
  final double temperatureCelsius; // Temp in °C
  final double rating; // 1.0 to 5.0
  final String notes;
  final DateTime createdAt;

  InfusionLog({
    required this.id,
    required this.dateTime,
    required this.category,
    required this.type,
    this.productId,
    required this.productName,
    required this.weightGrams,
    this.waterVolumeMl,
    required this.temperatureCelsius,
    this.rating = 5.0,
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  InfusionLog copyWith({
    String? id,
    DateTime? dateTime,
    InfusionCategory? category,
    InfusionType? type,
    String? productId,
    String? productName,
    double? weightGrams,
    double? waterVolumeMl,
    double? temperatureCelsius,
    double? rating,
    String? notes,
    DateTime? createdAt,
  }) {
    return InfusionLog(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      type: type ?? this.type,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      weightGrams: weightGrams ?? this.weightGrams,
      waterVolumeMl: waterVolumeMl ?? this.waterVolumeMl,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'category': category.name,
      'type': type.name,
      'productId': productId,
      'productName': productName,
      'weightGrams': weightGrams,
      'waterVolumeMl': waterVolumeMl,
      'temperatureCelsius': temperatureCelsius,
      'rating': rating,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory InfusionLog.fromMap(Map<String, dynamic> map) {
    return InfusionLog(
      id: map['id'] as String,
      dateTime: map['dateTime'] != null
          ? DateTime.tryParse(map['dateTime'] as String) ?? DateTime.now()
          : DateTime.now(),
      category: InfusionCategory.fromString(map['category'] as String? ?? 'mate'),
      type: InfusionType.fromString(map['type'] as String? ?? 'mateTradicional'),
      productId: map['productId'] as String?,
      productName: map['productName'] as String? ?? '',
      weightGrams: (map['weightGrams'] as num?)?.toDouble() ?? 30.0,
      waterVolumeMl: (map['waterVolumeMl'] as num?)?.toDouble(),
      temperatureCelsius: (map['temperatureCelsius'] as num?)?.toDouble() ?? 75.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      notes: map['notes'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
