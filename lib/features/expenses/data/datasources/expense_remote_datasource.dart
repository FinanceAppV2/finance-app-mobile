import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/expense_model.dart';

class ExpenseRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ExpenseRemoteDataSource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<ExpenseModel> createExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  }) async {
    final userId = await _getUserId();

    final data = <String, dynamic>{
      'description': description,
      'value': value,
      'category': category,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String().split('T')[0],
    };

    if (cardId != null) data['cardId'] = cardId;
    if (installments != null) data['installments'] = installments;

    final response = await _dio.post('/users/$userId/expenses', data: data);

    return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
