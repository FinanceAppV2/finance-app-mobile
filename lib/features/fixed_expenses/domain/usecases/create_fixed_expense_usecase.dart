import 'package:fpdart/fpdart.dart';

import '../entities/fixed_expense.dart';
import '../repositories/fixed_expenses_repository.dart';

class CreateFixedExpenseUseCase {
  final FixedExpensesRepository _repository;

  CreateFixedExpenseUseCase(this._repository);

  Future<Either<String, FixedExpense>> execute({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required int dueDay,
    String? cardId,
  }) {
    return _repository.createFixedExpense(
      description: description,
      value: value,
      category: category,
      paymentMethod: paymentMethod,
      dueDay: dueDay,
      cardId: cardId,
    );
  }
}
