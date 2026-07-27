import 'package:fpdart/fpdart.dart';

import '../repositories/home_repository.dart';

class UpdateExpenseUseCase {
  final HomeRepository _repository;

  UpdateExpenseUseCase(this._repository);

  Future<Either<String, Unit>> execute({
    required String id,
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  }) {
    return _repository.updateExpense(
      id: id,
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
