import 'package:fpdart/fpdart.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/expense_model.dart';
import '../models/monthly_summary_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, MonthlySummary>> getMonthlySummary({int? month, int? year}) async {
    try {
      final model = await _remoteDataSource.getMonthlySummary(month: month, year: year);
      return Right(_toEntity(model));
    } catch (e) {
      return Left('Erro ao carregar resumo: $e');
    }
  }

  @override
  Future<Either<String, List<Expense>>> getRecentExpenses({int? month, int? year, int limit = 5}) async {
    try {
      final models = await _remoteDataSource.getRecentExpenses(month: month, year: year, limit: limit);
      return Right(models.map(_toExpenseEntity).toList());
    } catch (e) {
      return Left('Erro ao carregar gastos: $e');
    }
  }

  MonthlySummary _toEntity(MonthlySummaryModel model) {
    return MonthlySummary(
      monthlyIncome: model.monthlyIncome,
      totalExpenses: model.totalExpenses,
      totalFixedExpenses: model.totalFixedExpenses,
      remaining: model.remaining,
      savingsGoalMonthly: model.savingsGoalMonthly,
      spendingLimitMonthly: model.spendingLimitMonthly,
    );
  }

  Expense _toExpenseEntity(ExpenseModel model) {
    return Expense(
      id: model.id,
      description: model.description,
      value: model.value,
      category: model.category,
      paymentMethod: model.paymentMethod,
      date: model.date,
    );
  }
}