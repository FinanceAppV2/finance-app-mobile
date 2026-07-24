import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../entities/monthly_summary.dart';

abstract class HomeRepository {
  Future<Either<String, MonthlySummary>> getMonthlySummary({int? month, int? year});
  Future<Either<String, List<Expense>>> getRecentExpenses({int? month, int? year, int limit = 5});
}