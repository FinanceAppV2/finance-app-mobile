import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/asset_model.dart';
import '../models/asset_projection_model.dart';
import '../models/portfolio_summary_model.dart';

class AssetRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AssetRemoteDataSource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<List<AssetModel>> getAssets() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/assets');
    final list = response.data as List;
    return list
        .map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PortfolioSummaryModel> getSummary() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/assets/summary');
    return PortfolioSummaryModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<AssetModel> createAsset({
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
    final userId = await _getUserId();
    final response = await _dio.post('/users/$userId/assets', data: {
      'name': name,
      'type': type,
      'category': category,
      'value': value,
      'investedValue': investedValue,
      'rate': ?rate,
      'rateType': ?rateType,
      'institution': ?institution,
      'dueDate': ?dueDate,
      'ticker': ?ticker,
      'notes': ?notes,
    });
    return AssetModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AssetModel> updateAsset({
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
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (type != null) data['type'] = type;
    if (category != null) data['category'] = category;
    if (value != null) data['value'] = value;
    if (investedValue != null) data['investedValue'] = investedValue;
    if (rate != null) data['rate'] = rate;
    if (rateType != null) data['rateType'] = rateType;
    if (institution != null) data['institution'] = institution;
    if (dueDate != null) data['dueDate'] = dueDate;
    if (ticker != null) data['ticker'] = ticker;
    if (notes != null) data['notes'] = notes;

    final response = await _dio.put('/assets/$id', data: data);
    return AssetModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteAsset({required String id}) async {
    await _dio.delete('/assets/$id');
  }

  Future<List<AssetModel>> updatePrices() async {
    final userId = await _getUserId();
    final response = await _dio.post('/users/$userId/assets/update-prices');
    final list = response.data as List;
    return list
        .map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AssetProjectionModel> getProjection({
    required String id,
    int months = 12,
  }) async {
    final response =
        await _dio.get('/assets/$id/projection', queryParameters: {
      'months': months,
    });
    return AssetProjectionModel.fromJson(
        response.data as Map<String, dynamic>);
  }
}
