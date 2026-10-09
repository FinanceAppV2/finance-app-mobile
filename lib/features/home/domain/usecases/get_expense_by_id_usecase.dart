import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../repositories/home_repository.dart';

class GetExpenseByIdUseCase {
  final HomeRepository _repository;

  GetExpenseByIdUseCase(this._repository);

  Future<Either<String, Expense>> execute(String id) {
    return _repository.getExpenseById(id);
  }
}
