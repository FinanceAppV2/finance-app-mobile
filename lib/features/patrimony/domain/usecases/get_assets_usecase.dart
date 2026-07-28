import 'package:fpdart/fpdart.dart';

import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class GetAssetsUseCase {
  final AssetRepository _repository;

  GetAssetsUseCase(this._repository);

  Future<Either<String, List<Asset>>> execute() {
    return _repository.getAssets();
  }
}
