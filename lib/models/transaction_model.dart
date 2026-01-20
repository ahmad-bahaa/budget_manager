class TransactionModel {
  final int? id;
  final double amount;
  final DateTime date;
  final int categoryId; // Foreign key
  final String? note;

  TransactionModel({
    this.id,
    required this.amount,
    required this.date,
    required this.categoryId,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      // Store date as ISO8601 String for easy SQL sorting/filtering
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      categoryId: map['category_id'],
      note: map['note'],
    );
  }

  TransactionModel copyWith({
    int? id,
    double? amount,
    DateTime? date,
    int? categoryId,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
    );
  }
}