class TransactionModel {
  final int? id;
  final double amount;
  final DateTime date;
  final int categoryId; // Foreign key
  final String? note;
  final bool isRecurring;
  final String? recurrenceInterval; // 'daily', 'weekly', 'monthly'
  final DateTime? lastProcessedDate;

  TransactionModel({
    this.id,
    required this.amount,
    required this.date,
    required this.categoryId,
    this.note,
    this.isRecurring = false,
    this.recurrenceInterval,
    this.lastProcessedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      // Store date as ISO8601 String for easy SQL sorting/filtering
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'note': note,
      'is_recurring': isRecurring ? 1 : 0,
      'recurrence_interval': recurrenceInterval,
      'last_processed_date': lastProcessedDate?.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      categoryId: map['category_id'],
      note: map['note'],
      isRecurring: map['is_recurring'] == 1,
      recurrenceInterval: map['recurrence_interval'],
      lastProcessedDate: map['last_processed_date'] != null
          ? DateTime.parse(map['last_processed_date'])
          : null,
    );
  }

  TransactionModel copyWith({
    int? id,
    double? amount,
    DateTime? date,
    int? categoryId,
    String? note,
    bool? isRecurring,
    String? recurrenceInterval,
    DateTime? lastProcessedDate,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      lastProcessedDate: lastProcessedDate ?? this.lastProcessedDate,
    );
  }
}
