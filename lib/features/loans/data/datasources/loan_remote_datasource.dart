import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/loan_model.dart';

class LoanRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  LoanRemoteDataSource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<List<LoanModel>> getLoans() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/loans');
    final list = response.data as List;
    return list
        .map((e) => LoanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LoanModel> getLoanById(String id) async {
    final response = await _dio.get('/loans/$id');
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<LoanModel> createLoan({
    required String description,
    required double totalValue,
    required int totalInstallments,
    required DateTime startDate,
    double monthlyInterestRate = 0,
  }) async {
    final userId = await _getUserId();
    final response = await _dio.post(
      '/users/$userId/loans',
      data: {
        'description': description,
        'totalValue': totalValue,
        'totalInstallments': totalInstallments,
        'monthlyInterestRate': monthlyInterestRate,
        'startDate': startDate.toIso8601String(),
      },
    );
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<LoanModel> updateLoan({
    required String id,
    String? description,
    double? totalValue,
    int? totalInstallments,
    double? monthlyInterestRate,
    DateTime? startDate,
    bool? active,
  }) async {
    final data = <String, dynamic>{};
    if (description != null) data['description'] = description;
    if (totalValue != null) data['totalValue'] = totalValue;
    if (totalInstallments != null) {
      data['totalInstallments'] = totalInstallments;
    }
    if (monthlyInterestRate != null) {
      data['monthlyInterestRate'] = monthlyInterestRate;
    }
    if (startDate != null) data['startDate'] = startDate.toIso8601String();
    if (active != null) data['active'] = active;

    final response = await _dio.put('/loans/$id', data: data);
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteLoan(String id) async {
    await _dio.delete('/loans/$id');
  }

  Future<List<LoanModel>> getActiveLoans({
    required int month,
    required int year,
  }) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/loans/active',
      queryParameters: {'month': month, 'year': year},
    );
    final list = response.data as List;
    return list
        .map((e) => LoanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
