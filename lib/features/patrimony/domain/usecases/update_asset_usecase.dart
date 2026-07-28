import 'package:fpdart/fpdart.dart';

import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class UpdateAssetUseCase {
  final AssetRepository _repository;

  UpdateAssetUseCase(this._repository);

  Future<Either<String, Asset>> execute({
    required String id,
    String? name,
    String? type,
    String? category,
    double? value,
    double? investedValue,
    double? rate,
    String? rateType,
    String? institution,
    String? dueDate,
    String? ticker,
    String? notes,
  }) {
    return _repository.updateAsset(
      id: id,
      name: name,
      type: type,
      category: category,
      value: value,
      investedValue: investedValue,
      rate: rate,
      rateType: rateType,
      institution: institution,
      dueDate: dueDate,
      ticker: ticker,
      notes: notes,
    );
  }
}
