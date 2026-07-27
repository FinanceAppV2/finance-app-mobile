import 'package:fpdart/fpdart.dart';

import '../../domain/entities/expense.dart';
import '../../domain/repositories/expenses_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpensesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, Expense>> createExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  }) async {
    try {
      final response = await _remoteDataSource.createExpense(
        description: description,
        value: value,
        category: category,
        paymentMethod: paymentMethod,
        date: date,
        cardId: cardId,
        installments: installments,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left('Erro ao cadastrar despesa: $e');
    }
  }
}
