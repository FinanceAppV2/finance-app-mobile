import 'package:fpdart/fpdart.dart';

import '../repositories/reports_repository.dart';

class GenerateAiUseCase {
  final ReportsRepository _repository;

  GenerateAiUseCase(this._repository);

  Future<Either<String, String>> execute({required String prompt}) {
    return _repository.generateAi(prompt: prompt);
  }
}
