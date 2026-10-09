import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/notification_model.dart';

class NotificationRemoteDatasource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  NotificationRemoteDatasource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final userId = await _storage.read(key: 'user_id');
    if (userId == null) throw Exception('User ID not found');
    return userId;
  }

  Future<NotificationModel> create({
    required String title,
    required String message,
    String type = 'INFO',
  }) async {
    final userId = await _getUserId();
    final response = await _dio.post(
      '/notifications',
      data: {
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
      },
    );
    return NotificationModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<NotificationModel> findById(String id) async {
    final response = await _dio.get('/notifications/$id');
    return NotificationModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<NotificationModel>> findAllByUserId({
    int limit = 50,
    int offset = 0,
  }) async {
    final userId = await _getUserId();
    final response = await _dio.get(
      '/users/$userId/notifications',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return (response.data as List)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NotificationModel>> findUnreadByUserId() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/notifications/unread');
    return (response.data as List)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> countUnreadByUserId() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/notifications/count/unread');
    return response.data as Map<String, dynamic>;
  }

  Future<NotificationModel> markAsRead(String id) async {
    final response = await _dio.patch('/notifications/$id/read');
    return NotificationModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> markAllAsReadByUserId() async {
    final userId = await _getUserId();
    final response = await _dio.patch('/users/$userId/notifications/read-all');
    return response.data as Map<String, dynamic>;
  }

  Future<NotificationModel> update(
    String id, {
    String? title,
    String? message,
    String? type,
    bool? read,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (message != null) data['message'] = message;
    if (type != null) data['type'] = type;
    if (read != null) data['read'] = read;

    final response = await _dio.put('/notifications/$id', data: data);
    return NotificationModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/notifications/$id');
  }

  Future<Map<String, dynamic>> deleteByUserId() async {
    final userId = await _getUserId();
    final response = await _dio.delete('/users/$userId/notifications');
    return response.data as Map<String, dynamic>;
  }
}
