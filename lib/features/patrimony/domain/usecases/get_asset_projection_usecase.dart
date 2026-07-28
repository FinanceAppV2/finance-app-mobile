import 'package:fpdart/fpdart.dart';

import '../entities/asset_projection.dart';
import '../repositories/asset_repository.dart';

class GetAssetProjectionUseCase {
  final AssetRepository _repository;

  GetAssetProjectionUseCase(this._repository);

  Future<Either<String, AssetProjection>> execute({
    required String id,
    int months = 12,
  }) {
    return _repository.getProjection(id: id, months: months);
  }
}
