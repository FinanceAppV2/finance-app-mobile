import 'package:fpdart/fpdart.dart';

import '../repositories/asset_repository.dart';

class DeleteAssetUseCase {
  final AssetRepository _repository;

  DeleteAssetUseCase(this._repository);

  Future<Either<String, void>> execute({required String id}) {
    return _repository.deleteAsset(id: id);
  }
}
