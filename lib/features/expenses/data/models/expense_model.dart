import '../../domain/entities/expense.dart';

class ExpenseModel {
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

  const ExpenseModel({
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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      category: json['category'] as String,
      paymentMethod: json['paymentMethod'] as String,
      cardId: json['cardId'] as String?,
      installments: json['installments'] as int?,
      date: DateTime.parse(json['date'] as String),
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
      'date': date.toIso8601String().split('T')[0],
      if (cardId != null) 'cardId': cardId,
      if (installments != null) 'installments': installments,
    };
  }

  Expense toEntity() {
    return Expense(
      id: id,
      userId: userId,
      description: description,
      value: value,
      category: category,
      paymentMethod: paymentMethod,
      cardId: cardId,
      installments: installments,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
