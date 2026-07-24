import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../repositories/home_repository.dart';

class GetRecentExpensesUseCase {
  final HomeRepository _repository;

  GetRecentExpensesUseCase(this._repository);

  Future<Either<String, List<Expense>>> execute({int? month, int? year, int limit = 5}) {
    return _repository.getRecentExpenses(month: month, year: year, limit: limit);
  }
}