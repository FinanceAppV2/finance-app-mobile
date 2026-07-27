import 'package:equatable/equatable.dart';

class FixedExpense extends Equatable {
  final String id;
  final String userId;
  final String description;
  final double value;
  final String category;
  final String paymentMethod;
  final String? cardId;
  final int dueDay;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FixedExpense({
    required this.id,
    required this.userId,
    required this.description,
    required this.value,
    required this.category,
    required this.paymentMethod,
    this.cardId,
    required this.dueDay,
    required this.active,
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
        dueDay,
        active,
        createdAt,
        updatedAt,
      ];
}
