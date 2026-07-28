import 'package:fpdart/fpdart.dart';

import '../entities/portfolio_summary.dart';
import '../repositories/asset_repository.dart';

class GetAssetSummaryUseCase {
  final AssetRepository _repository;

  GetAssetSummaryUseCase(this._repository);

  Future<Either<String, PortfolioSummary>> execute() {
    return _repository.getSummary();
  }
}
