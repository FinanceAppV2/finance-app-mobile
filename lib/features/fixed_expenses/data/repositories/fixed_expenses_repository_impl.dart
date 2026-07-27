import 'package:fpdart/fpdart.dart';

import '../../domain/entities/fixed_expense.dart';
import '../../domain/repositories/fixed_expenses_repository.dart';
import '../datasources/fixed_expense_remote_datasource.dart';

class FixedExpensesRepositoryImpl implements FixedExpensesRepository {
  final FixedExpenseRemoteDataSource _remoteDataSource;

  FixedExpensesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<FixedExpense>>> getFixedExpenses() async {
    try {
      final response = await _remoteDataSource.getFixedExpenses();
      return Right(response.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao buscar despesas fixas: $e');
    }
  }

  @override
  Future<Either<String, FixedExpense>> createFixedExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required int dueDay,
    String? cardId,
  }) async {
    try {
      final response = await _remoteDataSource.createFixedExpense(
        description: description,
        value: value,
        category: category,
        paymentMethod: paymentMethod,
        dueDay: dueDay,
        cardId: cardId,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left('Erro ao cadastrar despesa fixa: $e');
    }
  }
}
