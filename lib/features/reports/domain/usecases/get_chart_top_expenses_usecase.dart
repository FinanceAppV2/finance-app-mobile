import 'package:fpdart/fpdart.dart';

import '../entities/chart_top_expense.dart';
import '../repositories/reports_repository.dart';

class GetChartTopExpensesUseCase {
  final ReportsRepository _repository;
  GetChartTopExpensesUseCase(this._repository);
  Future<Either<String, List<ChartTopExpense>>> execute({int? year}) =>
      _repository.getTopExpenses(year: year);
}
