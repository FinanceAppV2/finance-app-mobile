import 'package:flutter/material.dart';

import '../../domain/entities/notification.dart' as notification_entity;
import '../../domain/usecases/notification_usecases.dart';

enum NotificationStatus { initial, loading, success, error }

class NotificationController extends ChangeNotifier {
  final GetAllNotificationsUseCase _getAllNotificationsUseCase;
  final GetUnreadNotificationsUseCase _getUnreadNotificationsUseCase;
  final CountUnreadNotificationsUseCase _countUnreadNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;

  NotificationController(
    this._getAllNotificationsUseCase,
    this._getUnreadNotificationsUseCase,
    this._countUnreadNotificationsUseCase,
    this._markAsReadUseCase,
    this._markAllAsReadUseCase,
    this._deleteNotificationUseCase,
  );

  NotificationStatus _status = NotificationStatus.initial;
  List<notification_entity.Notification> _notifications = [];
  List<notification_entity.Notification> _unreadNotifications = [];
  int _unreadCount = 0;
  String? _errorMessage;

  NotificationStatus get status => _status;
  List<notification_entity.Notification> get notifications => _notifications;
  List<notification_entity.Notification> get unreadNotifications => _unreadNotifications;
  int get unreadCount => _unreadCount;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotifications({int limit = 50, int offset = 0}) async {
    _status = NotificationStatus.loading;
    notifyListeners();

    final result = await _getAllNotificationsUseCase.execute(limit: limit, offset: offset);
    result.fold(
      (error) {
        _status = NotificationStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (notifications) {
        _notifications = notifications;
        _status = NotificationStatus.success;
        notifyListeners();
      },
    );
  }

  Future<void> loadUnreadNotifications() async {
    _status = NotificationStatus.loading;
    notifyListeners();

    final result = await _getUnreadNotificationsUseCase.execute();
    result.fold(
      (error) {
        _status = NotificationStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (notifications) {
        _unreadNotifications = notifications;
        _status = NotificationStatus.success;
        notifyListeners();
      },
    );
  }

  Future<void> countUnreadNotifications() async {
    final result = await _countUnreadNotificationsUseCase.execute();
    result.fold(
      (error) {
        _errorMessage = error;
      },
      (count) {
        _unreadCount = count;
        notifyListeners();
      },
    );
  }

  Future<bool> markAsRead(String id) async {
    final result = await _markAsReadUseCase.execute(id);
    return result.fold(
      (error) {
        _errorMessage = error;
        return false;
      },
      (_) {
        _notifications.removeWhere((n) => n.id == id);
        _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> markAllAsRead() async {
    final result = await _markAllAsReadUseCase.execute();
    return result.fold(
      (error) {
        _errorMessage = error;
        return false;
      },
      (count) {
        _unreadNotifications.clear();
        _unreadCount = 0;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteNotification(String id) async {
    final result = await _deleteNotificationUseCase.execute(id);
    return result.fold(
      (error) {
        _errorMessage = error;
        return false;
      },
      (_) {
        _notifications.removeWhere((n) => n.id == id);
        notifyListeners();
        return true;
      },
    );
  }
}
