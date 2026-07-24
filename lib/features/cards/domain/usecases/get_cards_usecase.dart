import 'package:fpdart/fpdart.dart';

import '../entities/card.dart';
import '../repositories/card_repository.dart';

class GetCardsUseCase {
  final CardRepository _repository;

  GetCardsUseCase(this._repository);

  Future<Either<String, List<CreditCard>>> execute() {
    return _repository.getCards();
  }
}