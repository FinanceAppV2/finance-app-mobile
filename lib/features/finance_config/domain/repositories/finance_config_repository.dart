import 'package:fpdart/fpdart.dart';

import '../entities/finance_config.dart';

abstract class FinanceConfigRepository {
  Future<Either<String, List<FinanceConfig>>> getFinanceConfig();
  Future<Either<String, List<FinanceConfig>>> updateFinanceConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
    required double emergencyFundGoal,
    String? type,
    double? cashBalance,
    int? salaryDay,
    int? paymentDay,
  });
}
