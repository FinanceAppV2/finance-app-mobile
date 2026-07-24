import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/finance_config_model.dart';

class FinanceConfigRemoteDatasource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  FinanceConfigRemoteDatasource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<FinanceConfigModel> getFinanceConfig() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/finance-config');
    return FinanceConfigModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<FinanceConfigModel> updateFinanceConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
  }) async {
    final userId = await _getUserId();

    try {
      final response = await _dio.put(
        '/users/$userId/finance-config',
        data: {
          'monthlyIncome': monthlyIncome,
          'spendingLimit': spendingLimit,
          'savingsGoal': savingsGoal,
        },
      );
      return FinanceConfigModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erro ao atualizar configuração financeira: $e');
    }
  }
}
