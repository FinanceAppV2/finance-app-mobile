import 'package:fpdart/fpdart.dart';

import '../entities/plan.dart';
import '../repositories/plan_repository.dart';

class SubscribePlanUseCase {
  final PlanRepository _repository;

  SubscribePlanUseCase(this._repository);

  Future<Either<String, Plan>> call({String? planId, String? planType}) {
    return _repository.subscribePlan(planId: planId, planType: planType);
  }
}
