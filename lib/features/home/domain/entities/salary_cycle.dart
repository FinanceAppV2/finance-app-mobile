import 'package:equatable/equatable.dart';

enum SalaryCycleStatus { green, yellow, red }

class SalaryCycle extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String label;
  final double monthlyIncome;
  final double expenses;
  final double fixedExpenses;
  final double installments;
  final double committed;
  final double available;
  final double healthyLimit;
  final double spendingLimitMonthly;
  final double savingsGoalMonthly;
  final int salaryDay;
  final int paymentDay;
  final SalaryCycleStatus status;
  final double budgetRemaining;
  final int daysRemainingInCycle;
  final double dailyBudget;
  final double weeklyBudget;

  const SalaryCycle({
    required this.startDate,
    required this.endDate,
    required this.label,
    required this.monthlyIncome,
    required this.expenses,
    required this.fixedExpenses,
    required this.installments,
    required this.committed,
    required this.available,
    required this.healthyLimit,
    required this.spendingLimitMonthly,
    required this.savingsGoalMonthly,
    required this.salaryDay,
    required this.paymentDay,
    required this.status,
    required this.budgetRemaining,
    required this.daysRemainingInCycle,
    required this.dailyBudget,
    required this.weeklyBudget,
  });

  double get committedPercentage =>
      spendingLimitMonthly <= 0 ? 0.0 : (committed / spendingLimitMonthly).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        label,
        monthlyIncome,
        expenses,
        fixedExpenses,
        installments,
        committed,
        available,
        healthyLimit,
        spendingLimitMonthly,
        savingsGoalMonthly,
        salaryDay,
        paymentDay,
        status,
        budgetRemaining,
        daysRemainingInCycle,
        dailyBudget,
        weeklyBudget,
      ];
}
