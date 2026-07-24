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
  }) {
    return _repository.updateFinanceConfig(
      monthlyIncome: monthlyIncome,
      spendingLimit: spendingLimit,
      savingsGoal: savingsGoal,
    );
  }
}
