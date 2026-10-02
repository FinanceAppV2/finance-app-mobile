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

  Future<List<FinanceConfigModel>> getFinanceConfig() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/finance-config');
    final data = response.data;
    return FinanceConfigModel.fromJson(data);
  }

  Future<List<FinanceConfigModel>> updateFinanceConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
    required double emergencyFundGoal,
    String? type,
    double? cashBalance,
    int? salaryDay,
    int? paymentDay,
  }) async {
    final userId = await _getUserId();

    try {
      final response = await _dio.put(
        '/users/$userId/finance-config',
        data: {
          'monthlyIncome': monthlyIncome,
          'spendingLimitMonthly': spendingLimit,
          'savingsGoalMonthly': savingsGoal,
          'emergencyFundGoal': emergencyFundGoal,
          'type': type,
          'cashBalance': cashBalance,
          'salaryDay': salaryDay,
          'paymentDay': paymentDay,
        },
      );
      final data = response.data;
      return FinanceConfigModel.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar configuração financeira: $e');
    }
  }
}
