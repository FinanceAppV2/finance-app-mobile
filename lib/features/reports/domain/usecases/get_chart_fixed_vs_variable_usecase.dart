import 'package:fpdart/fpdart.dart';

import '../entities/chart_fixed_vs_variable.dart';
import '../repositories/reports_repository.dart';

class GetChartFixedVsVariableUseCase {
  final ReportsRepository _repository;
  GetChartFixedVsVariableUseCase(this._repository);
  Future<Either<String, ChartFixedVsVariable>> execute({int? year}) =>
      _repository.getFixedVsVariable(year: year);
}
