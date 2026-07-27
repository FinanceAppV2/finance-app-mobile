import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../entities/monthly_summary.dart';

abstract class HomeRepository {
  Future<Either<String, MonthlySummary>> getMonthlySummary({int? month, int? year});
  Future<Either<String, List<Expense>>> getRecentExpenses({int? month, int? year, int limit = 5});
  Future<Either<String, Unit>> deleteExpense(String id);
  Future<Either<String, Unit>> updateExpense({
    required String id,
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  });
}