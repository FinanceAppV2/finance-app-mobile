import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _controller = GetIt.instance<NotificationController>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadNotifications();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Notificações',
          style: TextStyle(
            color: AppColors.marfim,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_controller.unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final success = await _controller.markAllAsRead();
                    if (!mounted) return;
                    if (success) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Todas as notificações marcadas como lidas'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      _controller.loadNotifications();
                    }
                  },
                  child: const Text(
                    'Marcar tudo como lido',
                    style: TextStyle(
                      color: AppColors.lataoClaro,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.status == NotificationStatus.loading && _controller.notifications.isEmpty) {
      return const ShimmerLoading(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              _SkeletonNotificationTile(),
              _SkeletonNotificationTile(),
              _SkeletonNotificationTile(),
            ],
          ),
        ),
      );
    }

    if (_controller.status == NotificationStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage ?? 'Erro ao carregar notificações',
              style: const TextStyle(color: AppColors.cinza),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.loadNotifications(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_controller.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              color: AppColors.cinza.withValues(alpha: 0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma notificação',
              style: TextStyle(
                color: AppColors.cinza.withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (_controller.unreadCount > 0) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Não lidas (${_controller.unreadCount})',
              style: const TextStyle(
                color: AppColors.marfim,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        ..._controller.notifications.map(
          (notification) {
            return NotificationTile(
              notification: notification,
              onDismiss: () async {
                final success = await _controller.deleteNotification(notification.id);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notificação deletada'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _SkeletonNotificationTile extends StatelessWidget {
  const _SkeletonNotificationTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.superficie.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.nevoa.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.nevoa.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  color: AppColors.nevoa.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  color: AppColors.nevoa.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
