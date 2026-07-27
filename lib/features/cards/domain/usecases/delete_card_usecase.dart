import 'package:fpdart/fpdart.dart';

import '../repositories/card_repository.dart';

class DeleteCardUseCase {
  final CardRepository _repository;

  DeleteCardUseCase(this._repository);

  Future<Either<String, void>> execute({required String id}) {
    return _repository.deleteCard(id: id);
  }
}
