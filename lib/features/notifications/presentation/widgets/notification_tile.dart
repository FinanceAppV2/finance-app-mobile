import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/notification.dart' as notification_entity;
import '../pages/notification_detail_page.dart';

class NotificationTile extends StatelessWidget {
  final notification_entity.Notification notification;
  final VoidCallback? onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onDismiss,
  });

  Color _getTypeColor(notification_entity.NotificationType type) {
    switch (type) {
      case notification_entity.NotificationType.alert:
        return AppColors.warning;
      case notification_entity.NotificationType.info:
        return AppColors.lataoClaro;
      case notification_entity.NotificationType.success:
        return AppColors.success;
      case notification_entity.NotificationType.warning:
        return AppColors.warning;
      case notification_entity.NotificationType.error:
        return AppColors.error;
    }
  }

  IconData _getTypeIcon(notification_entity.NotificationType type) {
    switch (type) {
      case notification_entity.NotificationType.alert:
        return Icons.warning_rounded;
      case notification_entity.NotificationType.info:
        return Icons.info_rounded;
      case notification_entity.NotificationType.success:
        return Icons.check_circle_rounded;
      case notification_entity.NotificationType.warning:
        return Icons.warning_amber_rounded;
      case notification_entity.NotificationType.error:
        return Icons.error_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(notification.type);
    final typeIcon = _getTypeIcon(notification.type);

    return Dismissible(
      key: Key(notification.id),
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        color: AppColors.error.withValues(alpha: 0.3),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_rounded, color: AppColors.error),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NotificationDetailPage(notification: notification),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: notification.read
                  ? AppColors.background.withValues(alpha: 0.5)
                  : AppColors.superficie.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notification.read ? AppColors.nevoa : typeColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          color: AppColors.marfim,
                          fontSize: 14,
                          fontWeight: notification.read ? FontWeight.w500 : FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: AppColors.cinza.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          color: AppColors.cinza.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.read)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: typeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'agora';
    } else if (diff.inMinutes < 60) {
      return 'há ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'há ${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return 'há ${diff.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
