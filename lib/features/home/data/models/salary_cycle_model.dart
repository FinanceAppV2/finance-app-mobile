import '../../domain/entities/salary_cycle.dart';

class SalaryCycleModel {
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
  final String status;
  final double budgetRemaining;
  final int daysRemainingInCycle;
  final double dailyBudget;
  final double weeklyBudget;

  const SalaryCycleModel({
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

  factory SalaryCycleModel.fromJson(Map<String, dynamic> json) {
    return SalaryCycleModel(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      label: json['label'] as String,
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      fixedExpenses: (json['fixedExpenses'] as num).toDouble(),
      installments: (json['installments'] as num).toDouble(),
      committed: (json['committed'] as num).toDouble(),
      available: (json['available'] as num).toDouble(),
      healthyLimit: (json['healthyLimit'] as num).toDouble(),
      spendingLimitMonthly: (json['spendingLimitMonthly'] as num).toDouble(),
      savingsGoalMonthly: (json['savingsGoalMonthly'] as num).toDouble(),
      salaryDay: (json['salaryDay'] as num).toInt(),
      paymentDay: (json['paymentDay'] as num).toInt(),
      status: json['status'] as String,
      budgetRemaining: (json['budgetRemaining'] as num?)?.toDouble() ?? 0.0,
      daysRemainingInCycle: (json['daysRemainingInCycle'] as num?)?.toInt() ?? 0,
      dailyBudget: (json['dailyBudget'] as num?)?.toDouble() ?? 0.0,
      weeklyBudget: (json['weeklyBudget'] as num?)?.toDouble() ?? 0.0,
    );
  }

  SalaryCycle toEntity() {
    return SalaryCycle(
      startDate: startDate,
      endDate: endDate,
      label: label,
      monthlyIncome: monthlyIncome,
      expenses: expenses,
      fixedExpenses: fixedExpenses,
      installments: installments,
      committed: committed,
      available: available,
      healthyLimit: healthyLimit,
      spendingLimitMonthly: spendingLimitMonthly,
      savingsGoalMonthly: savingsGoalMonthly,
      salaryDay: salaryDay,
      paymentDay: paymentDay,
      status: _parseStatus(status),
      budgetRemaining: budgetRemaining,
      daysRemainingInCycle: daysRemainingInCycle,
      dailyBudget: dailyBudget,
      weeklyBudget: weeklyBudget,
    );
  }

  SalaryCycleStatus _parseStatus(String s) {
    switch (s.toUpperCase()) {
      case 'YELLOW':
        return SalaryCycleStatus.yellow;
      case 'RED':
        return SalaryCycleStatus.red;
      default:
        return SalaryCycleStatus.green;
    }
  }
}
