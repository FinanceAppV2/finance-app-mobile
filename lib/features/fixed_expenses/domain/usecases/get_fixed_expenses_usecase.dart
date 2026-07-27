import 'package:fpdart/fpdart.dart';

import '../entities/fixed_expense.dart';
import '../repositories/fixed_expenses_repository.dart';

class GetFixedExpensesUseCase {
  final FixedExpensesRepository _repository;

  GetFixedExpensesUseCase(this._repository);

  Future<Either<String, List<FixedExpense>>> execute() {
    return _repository.getFixedExpenses();
  }
}
