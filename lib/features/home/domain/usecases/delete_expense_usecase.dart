import 'package:fpdart/fpdart.dart';

import '../repositories/home_repository.dart';

class DeleteExpenseUseCase {
  final HomeRepository _repository;

  DeleteExpenseUseCase(this._repository);

  Future<Either<String, Unit>> execute(String id) {
    return _repository.deleteExpense(id);
  }
}
