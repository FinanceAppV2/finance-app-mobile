import 'package:fpdart/fpdart.dart';

import '../entities/plan.dart';

abstract class PlanRepository {
  Future<Either<String, List<Plan>>> getPlans();
  Future<Either<String, Plan?>> getUserPlan();
  Future<Either<String, Plan>> subscribePlan({String? planId, String? planType});
}
