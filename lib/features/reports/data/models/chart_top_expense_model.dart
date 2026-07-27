import '../../domain/entities/chart_top_expense.dart';

class ChartTopExpenseModel {
  final String id;
  final String description;
  final double value;
  final String category;
  final String date;

  const ChartTopExpenseModel({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.date,
  });

  factory ChartTopExpenseModel.fromJson(Map<String, dynamic> json) {
    return ChartTopExpenseModel(
      id: json['id'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      category: json['category'] as String,
      date: json['date'] as String,
    );
  }

  ChartTopExpense toEntity() => ChartTopExpense(
        id: id,
        description: description,
        value: value,
        category: category,
        date: date,
      );
}
