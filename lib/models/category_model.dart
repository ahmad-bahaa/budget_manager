import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final int? id;
  final String name;
  final double monthlyLimit;
  final String colorHex;
  final int iconCode; // New field: Stores IconData.codePoint

  CategoryModel({
    this.id,
    required this.name,
    required this.monthlyLimit,
    required this.colorHex,
    required this.iconCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'monthly_limit': monthlyLimit,
      'color_hex': colorHex,
      'icon_code': iconCode,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      monthlyLimit: (map['monthly_limit'] as num).toDouble(),
      colorHex: map['color_hex'] as  String,
      iconCode: map['icon_code'] as int? ?? Icons.category.codePoint, // Fallback
    );
  }

  // Helper to get IconData
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

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
    int? iconCode,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      colorHex: colorHex ?? this.colorHex,
      iconCode: iconCode ?? this.iconCode,
    );
  }
}
