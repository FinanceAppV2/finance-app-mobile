class MonthlySummaryModel {
  final double monthlyIncome;
  final double totalExpenses;
  final double totalFixedExpenses;
  final double remaining;
  final double savingsGoalMonthly;
  final double spendingLimitMonthly;

  const MonthlySummaryModel({
    required this.monthlyIncome,
    required this.totalExpenses,
    required this.totalFixedExpenses,
    required this.remaining,
    required this.savingsGoalMonthly,
    required this.spendingLimitMonthly,
  });

  factory MonthlySummaryModel.fromJson(Map<String, dynamic> json) {
    return MonthlySummaryModel(
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      totalFixedExpenses: (json['totalFixedExpenses'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      savingsGoalMonthly: (json['savingsGoalMonthly'] as num).toDouble(),
      spendingLimitMonthly: (json['spendingLimitMonthly'] as num).toDouble(),
    );
  }

  double get totalOutgoing => totalExpenses + totalFixedExpenses;
}
