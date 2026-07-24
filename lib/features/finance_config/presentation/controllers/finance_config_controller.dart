import 'package:flutter/material.dart';

import '../../domain/entities/finance_config.dart';
import '../../domain/usecases/get_finance_config_usecase.dart';
import '../../domain/usecases/update_finance_config_usecase.dart';

enum FinanceConfigStatus { initial, loading, success, error }

class FinanceConfigController extends ChangeNotifier {
  final GetFinanceConfigUseCase _getFinanceConfigUseCase;
  final UpdateFinanceConfigUseCase _updateFinanceConfigUseCase;

  FinanceConfigStatus _status = FinanceConfigStatus.initial;
  FinanceConfig? _config;
  String? _errorMessage;

  FinanceConfigController(
    this._getFinanceConfigUseCase,
    this._updateFinanceConfigUseCase,
  );

  FinanceConfigStatus get status => _status;
  FinanceConfig? get config => _config;
  String? get errorMessage => _errorMessage;

  Future<void> loadConfig() async {
    _status = FinanceConfigStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getFinanceConfigUseCase.execute();

    result.fold(
      (error) {
        _status = FinanceConfigStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (config) {
        _config = config;
        _status = FinanceConfigStatus.success;
        notifyListeners();
      },
    );
  }

  Future<bool> updateConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
  }) async {
    _status = FinanceConfigStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _updateFinanceConfigUseCase.execute(
      monthlyIncome: monthlyIncome,
      spendingLimit: spendingLimit,
      savingsGoal: savingsGoal,
    );

    return result.fold(
      (error) {
        _status = FinanceConfigStatus.error;
        _errorMessage = error;
        notifyListeners();
        return false;
      },
      (config) {
        _config = config;
        _status = FinanceConfigStatus.success;
        notifyListeners();
        return true;
      },
    );
  }
}
