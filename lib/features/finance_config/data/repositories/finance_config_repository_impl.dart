import 'package:fpdart/fpdart.dart';

import '../../domain/entities/finance_config.dart';
import '../../domain/repositories/finance_config_repository.dart';
import '../datasources/finance_config_remote_datasource.dart';

class FinanceConfigRepositoryImpl implements FinanceConfigRepository {
  final FinanceConfigRemoteDatasource _remoteDatasource;

  FinanceConfigRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<String, FinanceConfig>> getFinanceConfig() async {
    try {
      final model = await _remoteDatasource.getFinanceConfig();
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao carregar configuração financeira: $e');
    }
  }

  @override
  Future<Either<String, FinanceConfig>> updateFinanceConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
  }) async {
    try {
      final model = await _remoteDatasource.updateFinanceConfig(
        monthlyIncome: monthlyIncome,
        spendingLimit: spendingLimit,
        savingsGoal: savingsGoal,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao atualizar configuração financeira: $e');
    }
  }
}
