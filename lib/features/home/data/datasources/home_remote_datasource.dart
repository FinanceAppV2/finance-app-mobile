import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../models/expense_model.dart';
import '../models/monthly_summary_model.dart';

class HomeRemoteDatasource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  HomeRemoteDatasource()
      : _dio = GetIt.instance<Dio>(),
        _storage = GetIt.instance<FlutterSecureStorage>();

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<MonthlySummaryModel> getMonthlySummary({int? month, int? year}) async {
    final userId = await _getUserId();
    final params = <String, dynamic>{};
    if (month != null) params['month'] = month;
    if (year != null) params['year'] = year;

    final response = await _dio.get(
      '/users/$userId/expenses/summary',
      queryParameters: params.isNotEmpty ? params : null,
    );
    return MonthlySummaryModel.fromJson(response.data);
  }

  Future<List<ExpenseModel>> getRecentExpenses({int? month, int? year, int limit = 5}) async {
    final userId = await _getUserId();
    final params = <String, dynamic>{};
    if (month != null) params['month'] = month;
    if (year != null) params['year'] = year;

    final response = await _dio.get(
      '/users/$userId/expenses',
      queryParameters: params.isNotEmpty ? params : null,
    );
    final list = (response.data as List).take(limit).toList();
    return list.map((e) => ExpenseModel.fromJson(e)).toList();
  }
}
