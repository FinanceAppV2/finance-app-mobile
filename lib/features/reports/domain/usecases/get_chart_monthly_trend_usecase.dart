import 'package:fpdart/fpdart.dart';

import '../entities/chart_monthly_trend.dart';
import '../repositories/reports_repository.dart';

class GetChartMonthlyTrendUseCase {
  final ReportsRepository _repository;
  GetChartMonthlyTrendUseCase(this._repository);
  Future<Either<String, List<ChartMonthlyTrend>>> execute({int? year}) =>
      _repository.getMonthlyTrend(year: year);
}
