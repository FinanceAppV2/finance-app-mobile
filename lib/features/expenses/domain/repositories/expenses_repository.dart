import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';

abstract class ExpensesRepository {
  Future<Either<String, Expense>> createExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  });
}
