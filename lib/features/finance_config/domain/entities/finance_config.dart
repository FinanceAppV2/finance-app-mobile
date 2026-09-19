import 'package:equatable/equatable.dart';

class FinanceConfig extends Equatable {
  final String id;
  final double monthlyIncome;
  final double spendingLimit;
  final double savingsGoal;
  final double emergencyFundGoal;
  final String type; // 'PREPAID' or 'POSPAID'
  final double? cashBalance;
  final int? salaryDay;
  final int? paymentDay;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FinanceConfig({
    required this.id,
    required this.monthlyIncome,
    required this.spendingLimit,
    required this.savingsGoal,
    required this.emergencyFundGoal,
    required this.type,
    this.cashBalance,
    this.salaryDay,
    this.paymentDay,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FinanceConfig.fromJson(Map<String, dynamic> json) {
    return FinanceConfig(
      id: json['id'],
      monthlyIncome: json['monthlyIncome'].toDouble(),
      spendingLimit: json['spendingLimitMonthly'].toDouble(),
      savingsGoal: json['savingsGoalMonthly'].toDouble(),
      emergencyFundGoal: json['emergencyFundGoal'].toDouble(),
      type: json['type'],
      cashBalance: json['cashBalance']?.toDouble(),
      salaryDay: json['salaryDay'],
      paymentDay: json['paymentDay'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthlyIncome': monthlyIncome,
      'spendingLimitMonthly': spendingLimit,
      'savingsGoalMonthly': savingsGoal,
      'emergencyFundGoal': emergencyFundGoal,
      'type': type,
      'cashBalance': cashBalance,
      'salaryDay': salaryDay,
      'paymentDay': paymentDay,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        monthlyIncome,
        spendingLimit,
        savingsGoal,
        emergencyFundGoal,
        type,
        cashBalance,
        salaryDay,
        paymentDay,
        createdAt,
        updatedAt,
      ];
}
