class ExpenseModel {
  final String id;
  final String description;
  final double value;
  final String category;
  final String paymentMethod;
  final String date;

  const ExpenseModel({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.paymentMethod,
    required this.date,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      category: json['category'] as String,
      paymentMethod: json['paymentMethod'] as String,
      date: json['date'] as String,
    );
  }
}
