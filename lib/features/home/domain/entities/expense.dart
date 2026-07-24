import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String description;
  final double value;
  final String category;
  final String paymentMethod;
  final String date;

  const Expense({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.paymentMethod,
    required this.date,
  });

  @override
  List<Object?> get props => [id, description, value, category, paymentMethod, date];
}