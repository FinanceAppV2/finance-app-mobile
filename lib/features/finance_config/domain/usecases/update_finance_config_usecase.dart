import 'package:fpdart/fpdart.dart';

import '../entities/finance_config.dart';
import '../repositories/finance_config_repository.dart';

class UpdateFinanceConfigUseCase {
  final FinanceConfigRepository _repository;

  UpdateFinanceConfigUseCase(this._repository);

  Future<Either<String, FinanceConfig>> execute({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
    required double emergencyFundGoal,
    String? type,
    double? cashBalance,
    int? salaryDay,
    int? paymentDay,
  }) {
    return _repository.updateFinanceConfig(
      monthlyIncome: monthlyIncome,
      spendingLimit: spendingLimit,
      savingsGoal: savingsGoal,
      emergencyFundGoal: emergencyFundGoal,
      type: type,
      cashBalance: cashBalance,
      salaryDay: salaryDay,
      paymentDay: paymentDay,
    );
  }
}
