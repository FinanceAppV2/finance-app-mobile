import 'package:fpdart/fpdart.dart';

import '../entities/chart_category.dart';
import '../repositories/reports_repository.dart';

class GetChartCategoriesUseCase {
  final ReportsRepository _repository;
  GetChartCategoriesUseCase(this._repository);
  Future<Either<String, List<ChartCategory>>> execute({int? year, int? month}) =>
      _repository.getCategories(year: year, month: month);
}
