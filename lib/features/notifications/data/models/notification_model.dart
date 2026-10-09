import '../../domain/entities/notification.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool read;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      read: json['read'] as bool,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Notification toEntity() {
    return Notification(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: _parseType(type),
      read: read,
      readAt: readAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  NotificationType _parseType(String t) {
    switch (t.toLowerCase()) {
      case 'alert':
        return NotificationType.alert;
      case 'success':
        return NotificationType.success;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      default:
        return NotificationType.info;
    }
  }
}
