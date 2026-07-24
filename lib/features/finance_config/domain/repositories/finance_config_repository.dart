import 'package:fpdart/fpdart.dart';

import '../entities/finance_config.dart';

abstract class FinanceConfigRepository {
  Future<Either<String, FinanceConfig>> getFinanceConfig();
  Future<Either<String, FinanceConfig>> updateFinanceConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
  });
}
