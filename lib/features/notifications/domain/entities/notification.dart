enum NotificationType { alert, info, success, warning, error }

class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool read;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notification({
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

  @override
  String toString() => 'Notification(id: $id, title: $title, type: $type, read: $read)';
}
