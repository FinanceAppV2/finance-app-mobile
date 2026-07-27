import 'package:fpdart/fpdart.dart';

import '../entities/chart_highest_month.dart';
import '../repositories/reports_repository.dart';

class GetChartHighestMonthUseCase {
  final ReportsRepository _repository;
  GetChartHighestMonthUseCase(this._repository);
  Future<Either<String, ChartHighestMonth>> execute({int? year}) =>
      _repository.getHighestMonth(year: year);
}
