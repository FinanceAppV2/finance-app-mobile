import 'package:fpdart/fpdart.dart';

import '../../domain/entities/asset.dart';
import '../../domain/entities/asset_projection.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/repositories/asset_repository.dart';
import '../datasources/asset_remote_datasource.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource _remoteDataSource;

  AssetRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<Asset>>> getAssets() async {
    try {
      final models = await _remoteDataSource.getAssets();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao carregar ativos: $e');
    }
  }

  @override
  Future<Either<String, PortfolioSummary>> getSummary() async {
    try {
      final model = await _remoteDataSource.getSummary();
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao carregar resumo: $e');
    }
  }

  @override
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
  }) async {
    try {
      final model = await _remoteDataSource.createAsset(
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
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao cadastrar ativo: $e');
    }
  }

  @override
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
  }) async {
    try {
      final model = await _remoteDataSource.updateAsset(
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
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao atualizar ativo: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteAsset({required String id}) async {
    try {
      await _remoteDataSource.deleteAsset(id: id);
      return const Right(null);
    } catch (e) {
      return Left('Erro ao excluir ativo: $e');
    }
  }

  @override
  Future<Either<String, List<Asset>>> updatePrices() async {
    try {
      final models = await _remoteDataSource.updatePrices();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao atualizar preços: $e');
    }
  }

  @override
  Future<Either<String, AssetProjection>> getProjection({
    required String id,
    int months = 12,
  }) async {
    try {
      final model =
          await _remoteDataSource.getProjection(id: id, months: months);
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao carregar projeção: $e');
    }
  }
}
