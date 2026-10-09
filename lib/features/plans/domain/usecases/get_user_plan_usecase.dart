import 'package:fpdart/fpdart.dart';

import '../entities/plan.dart';
import '../repositories/plan_repository.dart';

class GetUserPlanUseCase {
  final PlanRepository _repository;

  GetUserPlanUseCase(this._repository);

  Future<Either<String, Plan?>> call() {
    return _repository.getUserPlan();
  }
}
