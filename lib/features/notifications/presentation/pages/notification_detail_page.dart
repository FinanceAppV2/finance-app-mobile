import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/notification.dart' as notification_entity;
import '../controllers/notification_controller.dart';

class NotificationDetailPage extends StatefulWidget {
  final notification_entity.Notification notification;

  const NotificationDetailPage({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final _controller = GetIt.instance<NotificationController>();
  late notification_entity.Notification _notification;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notification = widget.notification;
    if (!_notification.read) {
      _markAsRead();
    }
  }

  Future<void> _markAsRead() async {
    setState(() => _isLoading = true);
    final success = await _controller.markAsRead(_notification.id);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        setState(() => _notification = _notification.copyWith(read: true, readAt: DateTime.now()));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notificação marcada como lida'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    }
  }

  Color _getTypeColor(notification_entity.NotificationType type) {
    switch (type) {
      case notification_entity.NotificationType.alert:
        return AppColors.warning;
      case notification_entity.NotificationType.info:
        return AppColors.verdeDestaque;
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'agora';
    } else if (diff.inMinutes < 60) {
      return 'há ${diff.inMinutes} minuto(s)';
    } else if (diff.inHours < 24) {
      return 'há ${diff.inHours} hora(s)';
    } else if (diff.inDays < 7) {
      return 'há ${diff.inDays} dia(s)';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(_notification.type);
    final typeIcon = _getTypeIcon(_notification.type);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.branco),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notificação',
          style: TextStyle(
            color: AppColors.branco,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.verdeDestaque),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.verdeEscuro.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: typeColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(typeIcon, color: typeColor, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: typeColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _notification.type.toString().split('.').last.toUpperCase(),
                                    style: TextStyle(
                                      color: typeColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _notification.read ? 'Lida' : 'Não lida',
                                  style: TextStyle(
                                    color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Título',
                      style: TextStyle(
                        color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _notification.title,
                      style: const TextStyle(
                        color: AppColors.branco,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Mensagem',
                      style: TextStyle(
                        color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _notification.message,
                      style: const TextStyle(
                        color: AppColors.branco,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cinzaEscuro.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recebida',
                                style: TextStyle(
                                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatDateTime(_notification.createdAt),
                                style: const TextStyle(
                                  color: AppColors.branco,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_notification.read && _notification.readAt != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lida em',
                                  style: TextStyle(
                                    color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatDateTime(_notification.readAt!),
                                  style: const TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}

extension on notification_entity.Notification {
  notification_entity.Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    notification_entity.NotificationType? type,
    bool? read,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return notification_entity.Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      read: read ?? this.read,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
