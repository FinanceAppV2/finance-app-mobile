import 'package:fpdart/fpdart.dart';

import '../../../home/domain/entities/salary_cycle.dart';
import '../entities/chart_category.dart';
import '../entities/chart_fixed_vs_variable.dart';
import '../entities/chart_highest_month.dart';
import '../entities/chart_monthly_trend.dart';
import '../entities/chart_payment_method.dart';
import '../entities/chart_top_expense.dart';

abstract class ReportsRepository {
  Future<Either<String, List<ChartPaymentMethod>>> getPaymentMethods({int? year, int? month});
  Future<Either<String, List<ChartCategory>>> getCategories({int? year, int? month});
  Future<Either<String, ChartHighestMonth>> getHighestMonth({int? year});
  Future<Either<String, List<ChartMonthlyTrend>>> getMonthlyTrend({int? year});
  Future<Either<String, ChartFixedVsVariable>> getFixedVsVariable({int? year, int? month});
  Future<Either<String, List<ChartTopExpense>>> getTopExpenses({int? year, int? month});
  Future<Either<String, Map<String, double>>> getMonthlySummary({int? month, int? year});
  Future<Either<String, String>> generateAi({required String prompt});
  Future<Either<String, List<SalaryCycle>>> getSalaryCycleHistory({int? limit});
}
