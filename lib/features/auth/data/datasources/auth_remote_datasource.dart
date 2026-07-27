import 'package:dio/dio.dart';

import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<LoginResponseModel> login({
    required String login,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'login': login,
      'password': password,
    });

    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> register({
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String cpf,
    required String password,
  }) async {

    try{
    final response = await _dio.post('/users', data: {
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'cpf': cpf,
      'password': password,
    });

    return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }

  }

  Future<UserModel> updateUser({
    required String id,
    String? name,
    String? lastName,
    String? email,
    String? phone,
    String? currentPassword,
    String? password,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (lastName != null) data['lastName'] = lastName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (currentPassword != null) data['currentPassword'] = currentPassword;
    if (password != null) data['password'] = password;

    final response = await _dio.put('/users/$id', data: data);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}