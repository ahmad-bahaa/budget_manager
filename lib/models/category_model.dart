import 'dart:ui';

class CategoryModel {
  final int? id; // Nullable for auto-increment during insert
  final String name;
  final double monthlyLimit;
  final String colorHex; // Stored as "0xFFRRGGBB"

  CategoryModel({
    this.id,
    required this.name,
    required this.monthlyLimit,
    required this.colorHex,
  });

  // Convert a Category into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'monthly_limit': monthlyLimit,
      'color_hex': colorHex,
    };
  }

  // Convert a Map into a Category.
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      monthlyLimit: (map['monthly_limit'] as num).toDouble(),
      colorHex: map['color_hex'],
    );
  }

  // Helper to get Color object from the stored Hex string
  Color get color {
    try {
      return Color(int.parse(colorHex));
    } catch (e) {
      return const Color(0xFF000000); // Fallback black
    }
  }

  // CopyWith for state updates (Riverpod friendly)
  CategoryModel copyWith({
    int? id,
    String? name,
    double? monthlyLimit,
    String? colorHex,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}