import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String userId;
  final String description;
  final double value;
  final String category;
  final String paymentMethod;
  final String? cardId;
  final int? installments;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Expense({
    required this.id,
    required this.userId,
    required this.description,
    required this.value,
    required this.category,
    required this.paymentMethod,
    this.cardId,
    this.installments,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        description,
        value,
        category,
        paymentMethod,
        cardId,
        installments,
        date,
        createdAt,
        updatedAt,
      ];
}
