import 'package:fpdart/fpdart.dart';

import '../../domain/entities/chart_category.dart';
import '../../domain/entities/chart_fixed_vs_variable.dart';
import '../../domain/entities/chart_highest_month.dart';
import '../../domain/entities/chart_monthly_trend.dart';
import '../../domain/entities/chart_payment_method.dart';
import '../../domain/entities/chart_top_expense.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _dataSource;

  ReportsRepositoryImpl(this._dataSource);

  @override
  Future<Either<String, List<ChartPaymentMethod>>> getPaymentMethods({int? year, int? month}) async {
    try {
      final models = await _dataSource.getPaymentMethods(year: year, month: month);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao carregar métodos de pagamento: $e');
    }
  }

  @override
  Future<Either<String, List<ChartCategory>>> getCategories({int? year, int? month}) async {
    try {
      final models = await _dataSource.getCategories(year: year, month: month);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao carregar categorias: $e');
    }
  }

  @override
  Future<Either<String, ChartHighestMonth>> getHighestMonth({int? year}) async {
    try {
      final model = await _dataSource.getHighestMonth(year: year);
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao carregar mês de maior gasto: $e');
    }
  }

  @override
  Future<Either<String, List<ChartMonthlyTrend>>> getMonthlyTrend({int? year}) async {
    try {
      final models = await _dataSource.getMonthlyTrend(year: year);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao carregar evolução mensal: $e');
    }
  }

  @override
  Future<Either<String, ChartFixedVsVariable>> getFixedVsVariable({int? year, int? month}) async {
    try {
      final model = await _dataSource.getFixedVsVariable(year: year, month: month);
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao carregar despesas fixas vs variáveis: $e');
    }
  }

  @override
  Future<Either<String, List<ChartTopExpense>>> getTopExpenses({int? year, int? month}) async {
    try {
      final models = await _dataSource.getTopExpenses(year: year, month: month);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao carregar maiores despesas: $e');
    }
  }
}
