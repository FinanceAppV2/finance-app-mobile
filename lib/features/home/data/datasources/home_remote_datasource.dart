import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/expense_model.dart';
import '../models/monthly_summary_model.dart';
import '../models/salary_cycle_model.dart';

class HomeRemoteDatasource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  HomeRemoteDatasource(this._dio, this._storage);

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

  Future<ExpenseModel> getExpenseById(String id) async {
    final response = await _dio.get('/expenses/$id');
    return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteExpense(String id) async {
    await _dio.delete('/expenses/$id');
  }

  Future<void> updateExpense({
    required String id,
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  }) async {
    final data = <String, dynamic>{
      'description': description,
      'value': value,
      'category': category,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String().split('T')[0],
    };
    if (cardId != null) data['cardId'] = cardId;
    if (installments != null) data['installments'] = installments;
    await _dio.put('/expenses/$id', data: data);
  }

  Future<SalaryCycleModel> getCurrentSalaryCycle({String? date}) async {
    final userId = await _getUserId();
    final params = <String, dynamic>{};
    if (date != null) params['date'] = date;
    final response = await _dio.get(
      '/users/$userId/salary-cycle/current',
      queryParameters: params.isNotEmpty ? params : null,
    );
    return SalaryCycleModel.fromJson(response.data as Map<String, dynamic>);
  }
}
