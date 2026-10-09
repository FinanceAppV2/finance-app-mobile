import 'package:flutter/material.dart';

import '../../domain/entities/plan.dart';
import '../../domain/usecases/get_plans_usecase.dart';
import '../../domain/usecases/get_user_plan_usecase.dart';
import '../../domain/usecases/subscribe_plan_usecase.dart';

class PlansController extends ChangeNotifier {
  final GetPlansUseCase _getPlansUseCase;
  final GetUserPlanUseCase _getUserPlanUseCase;
  final SubscribePlanUseCase _subscribePlanUseCase;

  PlansController(
    this._getPlansUseCase,
    this._getUserPlanUseCase,
    this._subscribePlanUseCase,
  );

  bool _isLoading = false;
  bool _isSubscribing = false;
  String? _errorMessage;
  String? _successMessage;
  List<Plan> _plans = [];
  Plan? _currentPlan;

  bool get isLoading => _isLoading;
  bool get isSubscribing => _isSubscribing;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  List<Plan> get plans => _plans;
  Plan? get currentPlan => _currentPlan;

  Future<void> loadPlans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final plansResult = await _getPlansUseCase();
    final userPlanResult = await _getUserPlanUseCase();

    plansResult.fold(
      (error) => _errorMessage = error,
      (plans) => _plans = plans,
    );

    userPlanResult.fold(
      (_) {},
      (userPlan) {
        if (userPlan != null) {
          _currentPlan = userPlan;
        } else if (_plans.isNotEmpty) {
          _currentPlan = _plans.firstWhere(
            (p) => p.isFree,
            orElse: () => _plans.first,
          );
        }
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> subscribe(Plan plan) async {
    _isSubscribing = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await _subscribePlanUseCase(planId: plan.id);
    bool success = false;

    result.fold(
      (error) {
        _errorMessage = error;
        success = false;
      },
      (updatedPlan) {
        _currentPlan = updatedPlan;
        _successMessage = 'Plano alterado para ${updatedPlan.name} com sucesso!';
        success = true;
      },
    );

    _isSubscribing = false;
    notifyListeners();
    return success;
  }
}
