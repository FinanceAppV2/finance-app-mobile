import 'package:fpdart/fpdart.dart';

import '../entities/finance_config.dart';
import '../repositories/finance_config_repository.dart';

class GetFinanceConfigUseCase {
  final FinanceConfigRepository _repository;

  GetFinanceConfigUseCase(this._repository);

  Future<Either<String, FinanceConfig>> execute() {
    return _repository.getFinanceConfig();
  }
}
