import 'package:flutter/material.dart';

import '../../domain/entities/finance_config.dart';
import '../../domain/usecases/get_finance_config_usecase.dart';
import '../../domain/usecases/update_finance_config_usecase.dart';

enum FinanceConfigStatus { initial, loading, success, error }

class FinanceConfigController extends ChangeNotifier {
  final GetFinanceConfigUseCase _getFinanceConfigUseCase;
  final UpdateFinanceConfigUseCase _updateFinanceConfigUseCase;

  FinanceConfigStatus _status = FinanceConfigStatus.initial;
  List<FinanceConfig> _configs = [];
  String? _errorMessage;

  FinanceConfigController(
    this._getFinanceConfigUseCase,
    this._updateFinanceConfigUseCase,
  );

  FinanceConfigStatus get status => _status;
  List<FinanceConfig> get configs => _configs;
  FinanceConfig? get postpaidConfig =>
      _configs.where((c) => c.type.toUpperCase() == 'POSPAID').firstOrNull;
  FinanceConfig? get prepaidConfig =>
      _configs.where((c) => c.type.toUpperCase() == 'PREPAID').firstOrNull;
  FinanceConfig? get config => _configs.isNotEmpty ? _configs.first : null;
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
      (configs) {
        _configs = configs;
        _status = FinanceConfigStatus.success;
        notifyListeners();
      },
    );
  }

  Future<bool> updateConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
    required double emergencyFundGoal,
    String? type,
    double? cashBalance,
    int? salaryDay,
    int? paymentDay,
  }) async {
    _status = FinanceConfigStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _updateFinanceConfigUseCase.execute(
      monthlyIncome: monthlyIncome,
      spendingLimit: spendingLimit,
      savingsGoal: savingsGoal,
      emergencyFundGoal: emergencyFundGoal,
      type: type,
      cashBalance: cashBalance,
      salaryDay: salaryDay,
      paymentDay: paymentDay,
    );

    return result.fold(
      (error) {
        _status = FinanceConfigStatus.error;
        _errorMessage = error;
        notifyListeners();
        return false;
      },
      (configs) {
        _configs = configs;
        _status = FinanceConfigStatus.success;
        notifyListeners();
        return true;
      },
    );
  }
}
