import 'package:fpdart/fpdart.dart';

import '../entities/salary_cycle.dart';
import '../repositories/home_repository.dart';

class GetCurrentSalaryCycleUseCase {
  final HomeRepository _repository;

  GetCurrentSalaryCycleUseCase(this._repository);

  Future<Either<String, SalaryCycle>> execute({String? date}) {
    return _repository.getCurrentSalaryCycle(date: date);
  }
}
