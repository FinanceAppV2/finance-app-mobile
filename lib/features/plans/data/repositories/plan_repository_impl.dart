import 'package:fpdart/fpdart.dart';

import '../../domain/entities/plan.dart';
import '../../domain/repositories/plan_repository.dart';
import '../datasources/plan_remote_datasource.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanRemoteDataSource _remoteDataSource;

  PlanRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<Plan>>> getPlans() async {
    try {
      final response = await _remoteDataSource.getPlans();
      return Right(response.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao buscar planos: $e');
    }
  }

  @override
  Future<Either<String, Plan?>> getUserPlan() async {
    try {
      final response = await _remoteDataSource.getUserPlan();
      return Right(response?.toEntity());
    } catch (e) {
      return Left('Erro ao buscar plano do usuário: $e');
    }
  }

  @override
  Future<Either<String, Plan>> subscribePlan({
    String? planId,
    String? planType,
  }) async {
    try {
      final response = await _remoteDataSource.subscribePlan(
        planId: planId,
        planType: planType,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left('Erro ao alterar plano: $e');
    }
  }
}
