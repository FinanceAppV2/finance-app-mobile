import 'package:fpdart/fpdart.dart';

import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class UpdateAssetPricesUseCase {
  final AssetRepository _repository;

  UpdateAssetPricesUseCase(this._repository);

  Future<Either<String, List<Asset>>> execute() {
    return _repository.updatePrices();
  }
}
