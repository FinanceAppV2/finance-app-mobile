import 'package:fpdart/fpdart.dart';

import '../repositories/notification_repository.dart';
import '../entities/notification.dart' as notification_entity;

class GetAllNotificationsUseCase {
  final NotificationRepository _repository;

  GetAllNotificationsUseCase(this._repository);

  Future<Either<String, List<notification_entity.Notification>>> execute({
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.findAllByUserId(limit: limit, offset: offset);
  }
}

class GetUnreadNotificationsUseCase {
  final NotificationRepository _repository;

  GetUnreadNotificationsUseCase(this._repository);

  Future<Either<String, List<notification_entity.Notification>>> execute() {
    return _repository.findUnreadByUserId();
  }
}

class CountUnreadNotificationsUseCase {
  final NotificationRepository _repository;

  CountUnreadNotificationsUseCase(this._repository);

  Future<Either<String, int>> execute() {
    return _repository.countUnreadByUserId();
  }
}

class MarkAsReadUseCase {
  final NotificationRepository _repository;

  MarkAsReadUseCase(this._repository);

  Future<Either<String, notification_entity.Notification>> execute(String id) {
    return _repository.markAsRead(id);
  }
}

class MarkAllAsReadUseCase {
  final NotificationRepository _repository;

  MarkAllAsReadUseCase(this._repository);

  Future<Either<String, int>> execute() {
    return _repository.markAllAsReadByUserId();
  }
}

class CreateNotificationUseCase {
  final NotificationRepository _repository;

  CreateNotificationUseCase(this._repository);

  Future<Either<String, notification_entity.Notification>> execute({
    required String title,
    required String message,
    String type = 'INFO',
  }) {
    return _repository.create(title: title, message: message, type: type);
  }
}

class DeleteNotificationUseCase {
  final NotificationRepository _repository;

  DeleteNotificationUseCase(this._repository);

  Future<Either<String, void>> execute(String id) {
    return _repository.delete(id);
  }
}
