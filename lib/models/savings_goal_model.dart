import 'dart:convert';

class SavingsGoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime? deadline;
  final int iconCodePoint;
  final String colorHex;

  SavingsGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    this.deadline,
    required this.iconCodePoint,
    required this.colorHex,
  });

  double get progress => (savedAmount / targetAmount).clamp(0.0, 1.0);

  SavingsGoalModel copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? deadline,
    int? iconCodePoint,
    String? colorHex,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      deadline: deadline ?? this.deadline,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline?.millisecondsSinceEpoch,
      'iconCodePoint': iconCodePoint,
      'colorHex': colorHex,
    };
  }

  factory SavingsGoalModel.fromMap(Map<String, dynamic> map) {
    return SavingsGoalModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0.0).toDouble(),
      savedAmount: (map['savedAmount'] ?? 0.0).toDouble(),
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'])
          : null,
      iconCodePoint: map['iconCodePoint'] ?? 0,
      colorHex: map['colorHex'] ?? '#FF000000',
    );
  }

  String toJson() => json.encode(toMap());

  factory SavingsGoalModel.fromJson(String source) =>
      SavingsGoalModel.fromMap(json.decode(source));
}
