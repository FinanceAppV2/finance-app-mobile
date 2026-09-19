import 'package:equatable/equatable.dart';

import '../../domain/entities/finance_config.dart';

class FinanceConfigModel extends Equatable {
  final String id;
  final double monthlyIncome;
  final double spendingLimit;
  final double savingsGoal;
  final double emergencyFundGoal;
  final String type;
  final double? cashBalance;
  final int? salaryDay;
  final int? paymentDay;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FinanceConfigModel({
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

  factory FinanceConfigModel.fromJson(Map<String, dynamic> json) {
    return FinanceConfigModel(
      id: json['id'],
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0,
      spendingLimit: (json['spendingLimitMonthly'] as num?)?.toDouble() ?? 0,
      savingsGoal: (json['savingsGoalMonthly'] as num?)?.toDouble() ?? 0,
      emergencyFundGoal: (json['emergencyFundGoal'] as num?)?.toDouble() ?? 0,
      type: json['type'],
      cashBalance: (json['cashBalance'] as num?)?.toDouble(),
      salaryDay: json['salaryDay'] as int?,
      paymentDay: json['paymentDay'] as int?,
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

  FinanceConfig toEntity() {
    return FinanceConfig(
      id: id,
      monthlyIncome: monthlyIncome,
      spendingLimit: spendingLimit,
      savingsGoal: savingsGoal,
      emergencyFundGoal: emergencyFundGoal,
      type: type,
      cashBalance: cashBalance,
      salaryDay: salaryDay,
      paymentDay: paymentDay,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
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
