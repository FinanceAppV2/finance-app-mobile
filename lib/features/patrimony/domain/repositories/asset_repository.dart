import 'package:fpdart/fpdart.dart';

import '../entities/asset.dart';
import '../entities/asset_projection.dart';
import '../entities/portfolio_summary.dart';

abstract class AssetRepository {
  Future<Either<String, List<Asset>>> getAssets();
  Future<Either<String, PortfolioSummary>> getSummary();
  Future<Either<String, Asset>> createAsset({
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
  });
  Future<Either<String, Asset>> updateAsset({
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
  });
  Future<Either<String, void>> deleteAsset({required String id});
  Future<Either<String, List<Asset>>> updatePrices();
  Future<Either<String, AssetProjection>> getProjection({
    required String id,
    int months = 12,
  });
}
