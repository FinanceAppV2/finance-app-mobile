import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../repositories/expenses_repository.dart';

class CreateExpenseUseCase {
  final ExpensesRepository _repository;

  CreateExpenseUseCase(this._repository);

  Future<Either<String, Expense>> execute({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  }) {
    return _repository.createExpense(
      description: description,
      value: value,
      category: category,
      paymentMethod: paymentMethod,
      date: date,
      cardId: cardId,
      installments: installments,
    );
  }
}
