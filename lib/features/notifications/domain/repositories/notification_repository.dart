import 'package:fpdart/fpdart.dart';

import '../../domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<String, Notification>> create({
    required String title,
    required String message,
    String type,
  });

  Future<Either<String, Notification>> findById(String id);

  Future<Either<String, List<Notification>>> findAllByUserId({
    int limit,
    int offset,
  });

  Future<Either<String, List<Notification>>> findUnreadByUserId();

  Future<Either<String, int>> countUnreadByUserId();

  Future<Either<String, Notification>> markAsRead(String id);

  Future<Either<String, int>> markAllAsReadByUserId();

  Future<Either<String, Notification>> update(
    String id, {
    String? title,
    String? message,
    String? type,
    bool? read,
  });

  Future<Either<String, void>> delete(String id);

  Future<Either<String, int>> deleteByUserId();
}
