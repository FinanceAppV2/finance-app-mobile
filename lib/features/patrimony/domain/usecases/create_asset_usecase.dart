import 'package:fpdart/fpdart.dart';

import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class CreateAssetUseCase {
  final AssetRepository _repository;

  CreateAssetUseCase(this._repository);

  Future<Either<String, Asset>> execute({
    required String name,
    required String type,
    required String category,
    required double value,
    required double investedValue,
    double? rate,
    String? rateType,
    String? institution,
    String? dueDate,
    String? ticker,
    String? notes,
  }) {
    return _repository.createAsset(
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
