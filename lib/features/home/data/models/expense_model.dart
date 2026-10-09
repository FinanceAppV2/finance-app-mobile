class ExpenseModel {
  final String id;
  final String description;
  final double value;
  final String category;
  final String paymentMethod;
  final String date;
  final String? cardId;
  final int? installments;
  final String type;

  const ExpenseModel({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.paymentMethod,
    required this.date,
    this.cardId,
    this.installments,
    this.type = 'EXPENSE',
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      category: json['category'] as String,
      paymentMethod: json['paymentMethod'] as String,
      date: json['date'] as String,
      cardId: json['cardId'] as String?,
      installments: (json['installments'] as num?)?.toInt(),
      type: json['type'] as String? ?? 'EXPENSE',
    );
  }
}
