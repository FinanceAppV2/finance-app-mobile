import 'package:fpdart/fpdart.dart';

import '../entities/monthly_summary.dart';
import '../repositories/home_repository.dart';

class GetMonthlySummaryUseCase {
  final HomeRepository _repository;

  GetMonthlySummaryUseCase(this._repository);

  Future<Either<String, MonthlySummary>> execute({int? month, int? year}) {
    return _repository.getMonthlySummary(month: month, year: year);
  }
}