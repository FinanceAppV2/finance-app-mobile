import 'package:equatable/equatable.dart';

class FinanceConfig extends Equatable {
  final double monthlyIncome;
  final double spendingLimit;
  final double savingsGoal;

  const FinanceConfig({
    required this.monthlyIncome,
    required this.spendingLimit,
    required this.savingsGoal,
  });

  @override
  List<Object?> get props => [monthlyIncome, spendingLimit, savingsGoal];
}
