import 'package:flutter/material.dart';

import '../../../../../../features/notifications/domain/repositories/notification_repository.dart';
import '../../../../../../features/notifications/domain/usecases/notification_usecases.dart';

class NotificationBadgeController extends ChangeNotifier {
  final CountUnreadNotificationsUseCase _countUnreadUseCase;
  int _unreadCount = 0;

  NotificationBadgeController(this._countUnreadUseCase);

  int get unreadCount => _unreadCount;

  Future<void> loadUnreadCount() async {
    final result = await _countUnreadUseCase.execute();
    result.fold(
      (error) {
        _unreadCount = 0;
      },
      (count) {
        _unreadCount = count;
        notifyListeners();
      },
    );
  }

  void increment() {
    _unreadCount++;
    notifyListeners();
  }

  void decrement() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }

  void reset() {
    _unreadCount = 0;
    notifyListeners();
  }
}
