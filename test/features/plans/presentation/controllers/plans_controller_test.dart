import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finance_app_mobile/features/plans/domain/entities/plan.dart';
import 'package:finance_app_mobile/features/plans/domain/repositories/plan_repository.dart';
import 'package:finance_app_mobile/features/plans/domain/usecases/get_plans_usecase.dart';
import 'package:finance_app_mobile/features/plans/domain/usecases/get_user_plan_usecase.dart';
import 'package:finance_app_mobile/features/plans/domain/usecases/subscribe_plan_usecase.dart';
import 'package:finance_app_mobile/features/plans/presentation/controllers/plans_controller.dart';

class FakePlanRepository implements PlanRepository {
  List<Plan> plans = [
    Plan(
      id: 'plan-1',
      type: 'FREE',
      name: 'Grátis',
      description: 'Controle manual',
      price: 0,
      billingPeriod: 'MONTHLY',
      active: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Plan(
      id: 'plan-2',
      type: 'PLUS',
      name: 'Plus',
      description: 'Controle automático',
      price: 9.9,
      billingPeriod: 'MONTHLY',
      active: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Plan? currentPlan;
  bool shouldFail = false;

  @override
  Future<Either<String, List<Plan>>> getPlans() async {
    if (shouldFail) return const Left('Erro ao buscar planos');
    return Right(plans);
  }

  @override
  Future<Either<String, Plan?>> getUserPlan() async {
    if (shouldFail) return const Left('Erro ao buscar plano');
    return Right(currentPlan ?? plans.first);
  }

  @override
  Future<Either<String, Plan>> subscribePlan({
    String? planId,
    String? planType,
  }) async {
    if (shouldFail) return const Left('Erro ao alterar plano');
    final selected = plans.firstWhere((p) => p.id == planId || p.type == planType);
    currentPlan = selected;
    return Right(selected);
  }
}

void main() {
  late FakePlanRepository fakeRepository;
  late PlansController controller;

  setUp(() {
    fakeRepository = FakePlanRepository();
    controller = PlansController(
      GetPlansUseCase(fakeRepository),
      GetUserPlanUseCase(fakeRepository),
      SubscribePlanUseCase(fakeRepository),
    );
  });

  group('PlansController', () {
    test('loadPlans loads all plans and sets user plan', () async {
      await controller.loadPlans();

      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNull);
      expect(controller.plans.length, 2);
      expect(controller.currentPlan?.type, 'FREE');
    });

    test('subscribe changes current plan successfully', () async {
      await controller.loadPlans();
      final plusPlan = controller.plans[1];

      final success = await controller.subscribe(plusPlan);

      expect(success, isTrue);
      expect(controller.currentPlan?.type, 'PLUS');
      expect(controller.successMessage, contains('Plus'));
    });

    test('subscribe handles error gracefully', () async {
      await controller.loadPlans();
      fakeRepository.shouldFail = true;

      final success = await controller.subscribe(controller.plans[1]);

      expect(success, isFalse);
      expect(controller.errorMessage, isNotNull);
    });
  });
}
