import 'package:equatable/equatable.dart';

import '../../domain/entities/finance_config.dart';

class FinanceConfigModel extends Equatable {
  final double monthlyIncome;
  final double spendingLimit;
  final double savingsGoal;

  const FinanceConfigModel({
    required this.monthlyIncome,
    required this.spendingLimit,
    required this.savingsGoal,
  });

  factory FinanceConfigModel.fromJson(Map<String, dynamic> json) {
    return FinanceConfigModel(
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0,
      spendingLimit: (json['spendingLimit'] as num?)?.toDouble() ?? 0,
      savingsGoal: (json['savingsGoal'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthlyIncome': monthlyIncome,
      'spendingLimit': spendingLimit,
      'savingsGoal': savingsGoal,
    };
  }

  FinanceConfig toEntity() {
    return FinanceConfig(
      monthlyIncome: monthlyIncome,
      spendingLimit: spendingLimit,
      savingsGoal: savingsGoal,
    );
  }

  @override
  List<Object?> get props => [monthlyIncome, spendingLimit, savingsGoal];
}
