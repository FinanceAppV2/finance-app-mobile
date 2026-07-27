import 'package:equatable/equatable.dart';

class ChartTopExpense extends Equatable {
  final String id;
  final String description;
  final double value;
  final String category;
  final String date;

  const ChartTopExpense({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.date,
  });

  @override
  List<Object?> get props => [id, description, value, category, date];
}
