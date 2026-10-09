import 'package:fpdart/fpdart.dart';

import '../../../home/domain/entities/salary_cycle.dart';
import '../repositories/reports_repository.dart';

class GetSalaryCycleHistoryUseCase {
  final ReportsRepository _repository;

  GetSalaryCycleHistoryUseCase(this._repository);

  Future<Either<String, List<SalaryCycle>>> execute({int? limit}) {
    return _repository.getSalaryCycleHistory(limit: limit);
  }
}
