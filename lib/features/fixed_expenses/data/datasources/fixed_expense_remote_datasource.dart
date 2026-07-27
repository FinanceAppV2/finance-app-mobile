import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/fixed_expense_model.dart';

class FixedExpenseRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  FixedExpenseRemoteDataSource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<List<FixedExpenseModel>> getFixedExpenses() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/fixed-expenses');
    final list = response.data as List;
    return list
        .map((e) => FixedExpenseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FixedExpenseModel> createFixedExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required int dueDay,
    String? cardId,
  }) async {
    final userId = await _getUserId();

    final data = <String, dynamic>{
      'description': description,
      'value': value,
      'category': category,
      'paymentMethod': paymentMethod,
      'dueDay': dueDay,
    };

    if (cardId != null) data['cardId'] = cardId;

    final response = await _dio.post(
      '/users/$userId/fixed-expenses',
      data: data,
    );

    return FixedExpenseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
