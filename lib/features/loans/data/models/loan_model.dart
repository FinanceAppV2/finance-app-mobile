import '../../domain/entities/loan.dart';

class LoanModel {
  final String id;
  final String userId;
  final String description;
  final double totalValue;
  final int totalInstallments;
  final double installmentValue;
  final double monthlyInterestRate;
  final double totalWithInterest;
  final DateTime startDate;
  final bool active;
  final int? currentInstallment;
  final DateTime? nextInstallmentDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LoanModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.totalValue,
    required this.totalInstallments,
    required this.installmentValue,
    required this.monthlyInterestRate,
    required this.totalWithInterest,
    required this.startDate,
    required this.active,
    this.currentInstallment,
    this.nextInstallmentDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String,
      totalValue: (json['totalValue'] as num).toDouble(),
      totalInstallments: json['totalInstallments'] as int,
      installmentValue: (json['installmentValue'] as num).toDouble(),
      monthlyInterestRate: (json['monthlyInterestRate'] as num).toDouble(),
      totalWithInterest: (json['totalWithInterest'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      active: json['active'] as bool,
      currentInstallment: json['currentInstallment'] as int?,
      nextInstallmentDate: json['nextInstallmentDate'] != null
          ? DateTime.parse(json['nextInstallmentDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'totalValue': totalValue,
      'totalInstallments': totalInstallments,
      'monthlyInterestRate': monthlyInterestRate,
      'startDate': startDate.toIso8601String(),
    };
  }

  Loan toEntity() {
    return Loan(
      id: id,
      userId: userId,
      description: description,
      totalValue: totalValue,
      totalInstallments: totalInstallments,
      installmentValue: installmentValue,
      monthlyInterestRate: monthlyInterestRate,
      totalWithInterest: totalWithInterest,
      startDate: startDate,
      active: active,
      currentInstallment: currentInstallment,
      nextInstallmentDate: nextInstallmentDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
