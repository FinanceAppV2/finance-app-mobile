import 'package:fpdart/fpdart.dart';

import '../entities/fixed_expense.dart';

abstract class FixedExpensesRepository {
  Future<Either<String, List<FixedExpense>>> getFixedExpenses();
  Future<Either<String, FixedExpense>> createFixedExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required int dueDay,
    String? cardId,
  });
}
