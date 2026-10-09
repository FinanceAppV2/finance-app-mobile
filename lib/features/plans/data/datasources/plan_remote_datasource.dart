import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/plan_model.dart';

class PlanRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  PlanRemoteDataSource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<List<PlanModel>> getPlans() async {
    final response = await _dio.get('/plans');
    final list = response.data as List;
    return list
        .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PlanModel?> getUserPlan() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/plan');
    if (response.data == null) return null;
    return PlanModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PlanModel> subscribePlan({String? planId, String? planType}) async {
    final userId = await _getUserId();
    final response = await _dio.post(
      '/users/$userId/plan/subscribe',
      data: {
        'planId': ?planId,
        'planType': ?planType,
      },
    );
    return PlanModel.fromJson(response.data as Map<String, dynamic>);
  }
}
