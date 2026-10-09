import 'package:fpdart/fpdart.dart';

import '../entities/plan.dart';
import '../repositories/plan_repository.dart';

class GetPlansUseCase {
  final PlanRepository _repository;

  GetPlansUseCase(this._repository);

  Future<Either<String, List<Plan>>> call() {
    return _repository.getPlans();
  }
}
