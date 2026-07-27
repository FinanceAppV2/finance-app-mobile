import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/chart_category_model.dart';
import '../models/chart_fixed_vs_variable_model.dart';
import '../models/chart_highest_month_model.dart';
import '../models/chart_monthly_trend_model.dart';
import '../models/chart_payment_method_model.dart';
import '../models/chart_top_expense_model.dart';

class ReportsRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ReportsRemoteDataSource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Map<String, dynamic> _params({int? year}) {
    final params = <String, dynamic>{};
    if (year != null) params['year'] = year;
    return params;
  }

  Future<List<ChartPaymentMethodModel>> getPaymentMethods({int? year}) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/charts/payment-methods',
      queryParameters: _params(year: year),
    );
    return (response.data as List).map((e) => ChartPaymentMethodModel.fromJson(e)).toList();
  }

  Future<List<ChartCategoryModel>> getCategories({int? year}) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/charts/categories',
      queryParameters: _params(year: year),
    );
    return (response.data as List).map((e) => ChartCategoryModel.fromJson(e)).toList();
  }

  Future<ChartHighestMonthModel> getHighestMonth({int? year}) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/charts/highest-month',
      queryParameters: _params(year: year),
    );
    return ChartHighestMonthModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ChartMonthlyTrendModel>> getMonthlyTrend({int? year}) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/charts/monthly-trend',
      queryParameters: _params(year: year),
    );
    return (response.data as List).map((e) => ChartMonthlyTrendModel.fromJson(e)).toList();
  }

  Future<ChartFixedVsVariableModel> getFixedVsVariable({int? year}) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/charts/fixed-vs-variable',
      queryParameters: _params(year: year),
    );
    return ChartFixedVsVariableModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ChartTopExpenseModel>> getTopExpenses({int? year}) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/charts/top-expenses',
      queryParameters: _params(year: year),
    );
    return (response.data as List).map((e) => ChartTopExpenseModel.fromJson(e)).toList();
  }
}
