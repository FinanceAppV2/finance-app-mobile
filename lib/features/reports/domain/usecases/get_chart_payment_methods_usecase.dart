import 'package:fpdart/fpdart.dart';

import '../entities/chart_payment_method.dart';
import '../repositories/reports_repository.dart';

class GetChartPaymentMethodsUseCase {
  final ReportsRepository _repository;
  GetChartPaymentMethodsUseCase(this._repository);
  Future<Either<String, List<ChartPaymentMethod>>> execute({int? year}) =>
      _repository.getPaymentMethods(year: year);
}
