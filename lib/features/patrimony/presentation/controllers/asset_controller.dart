import 'package:flutter/material.dart';

import '../../domain/entities/asset.dart';
import '../../domain/entities/asset_projection.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/usecases/create_asset_usecase.dart';
import '../../domain/usecases/delete_asset_usecase.dart';
import '../../domain/usecases/get_asset_projection_usecase.dart';
import '../../domain/usecases/get_asset_summary_usecase.dart';
import '../../domain/usecases/get_assets_usecase.dart';
import '../../domain/usecases/update_asset_prices_usecase.dart';
import '../../domain/usecases/update_asset_usecase.dart';

enum AssetStatus { initial, loading, success, error }

class AssetController extends ChangeNotifier {
  final GetAssetsUseCase _getAssetsUseCase;
  final GetAssetSummaryUseCase _getAssetSummaryUseCase;
  final CreateAssetUseCase _createAssetUseCase;
  final DeleteAssetUseCase _deleteAssetUseCase;
  final UpdateAssetUseCase _updateAssetUseCase;
  final UpdateAssetPricesUseCase _updateAssetPricesUseCase;
  final GetAssetProjectionUseCase _getAssetProjectionUseCase;

  AssetStatus _status = AssetStatus.initial;
  List<Asset> _assets = [];
  PortfolioSummary? _summary;
  AssetProjection? _projection;
  String? _errorMessage;

  AssetController(
    this._getAssetsUseCase,
    this._getAssetSummaryUseCase,
    this._createAssetUseCase,
    this._updateAssetUseCase,
    this._deleteAssetUseCase,
    this._updateAssetPricesUseCase,
    this._getAssetProjectionUseCase,
  );

  AssetStatus get status => _status;
  List<Asset> get assets => _assets;
  PortfolioSummary? get summary => _summary;
  AssetProjection? get projection => _projection;
  String? get errorMessage => _errorMessage;

  Future<void> loadAssets() async {
    _status = AssetStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getAssetsUseCase.execute();

    result.fold(
      (error) {
        _status = AssetStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (assets) {
        _assets = assets;
        _status = AssetStatus.success;
        notifyListeners();
      },
    );
  }

  Future<void> loadSummary() async {
    final result = await _getAssetSummaryUseCase.execute();

    result.fold(
      (error) {
        _errorMessage = error;
        notifyListeners();
      },
      (summary) {
        _summary = summary;
        notifyListeners();
      },
    );
  }

  Future<bool> createAsset({
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
    final result = await _createAssetUseCase.execute(
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

    return result.fold(
      (error) {
        _errorMessage = error;
        notifyListeners();
        return false;
      },
      (_) {
        loadAssets();
        loadSummary();
        return true;
      },
    );
  }

  Future<bool> updateAsset({
    required String id,
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
    final result = await _updateAssetUseCase.execute(
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

    return result.fold(
      (error) {
        _errorMessage = error;
        notifyListeners();
        return false;
      },
      (_) {
        loadAssets();
        loadSummary();
        return true;
      },
    );
  }

  Future<bool> deleteAsset({required String id}) async {
    final result = await _deleteAssetUseCase.execute(id: id);

    return result.fold(
      (error) {
        _errorMessage = error;
        notifyListeners();
        return false;
      },
      (_) {
      loadAssets();
      loadSummary();
      return true;
    },
  );
  }

  Future<bool> updatePrices() async {
    _status = AssetStatus.loading;
    notifyListeners();

    final result = await _updateAssetPricesUseCase.execute();

    return result.fold(
      (error) {
        _errorMessage = error;
        _status = AssetStatus.error;
        notifyListeners();
        return false;
      },
      (assets) {
        _assets = assets;
        _status = AssetStatus.success;
        notifyListeners();
        loadSummary();
        return true;
      },
    );
  }

  Future<void> loadProjection({required String id, int months = 12}) async {
    _projection = null;
    notifyListeners();

    final result = await _getAssetProjectionUseCase.execute(
      id: id,
      months: months,
    );

    result.fold(
      (error) {
        _errorMessage = error;
        notifyListeners();
      },
      (projection) {
        _projection = projection;
        notifyListeners();
      },
    );
  }
}
