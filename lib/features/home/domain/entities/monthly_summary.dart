import 'package:equatable/equatable.dart';

class MonthlySummary extends Equatable {
  final double monthlyIncome;
  final double totalExpenses;
  final double totalFixedExpenses;
  final double remaining;
  final double savingsGoalMonthly;
  final double spendingLimitMonthly;

  const MonthlySummary({
    required this.monthlyIncome,
    required this.totalExpenses,
    required this.totalFixedExpenses,
    required this.remaining,
    required this.savingsGoalMonthly,
    required this.spendingLimitMonthly,
  });

  double get totalOutgoing => totalExpenses + totalFixedExpenses;

  @override
  List<Object?> get props => [
        monthlyIncome,
        totalExpenses,
        totalFixedExpenses,
        remaining,
        savingsGoalMonthly,
        spendingLimitMonthly,
      ];
}