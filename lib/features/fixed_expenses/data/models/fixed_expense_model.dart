import '../../domain/entities/fixed_expense.dart';

class FixedExpenseModel {
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

  const FixedExpenseModel({
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

  factory FixedExpenseModel.fromJson(Map<String, dynamic> json) {
    return FixedExpenseModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      category: json['category'] as String,
      paymentMethod: json['paymentMethod'] as String,
      cardId: json['cardId'] as String?,
      dueDay: json['dueDay'] as int,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'value': value,
      'category': category,
      'paymentMethod': paymentMethod,
      'dueDay': dueDay,
      if (cardId != null) 'cardId': cardId,
    };
  }

  FixedExpense toEntity() {
    return FixedExpense(
      id: id,
      userId: userId,
      description: description,
      value: value,
      category: category,
      paymentMethod: paymentMethod,
      cardId: cardId,
      dueDay: dueDay,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
