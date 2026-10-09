import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/controllers/notification_badge_controller.dart';

class HomeHeader extends StatefulWidget {
  final String greeting;
  final String userName;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onReload;

  const HomeHeader({
    super.key,
    required this.greeting,
    required this.userName,
    this.onMenuPressed,
    this.onReload,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late final NotificationBadgeController _badgeController;

  @override
  void initState() {
    super.initState();
    _badgeController = GetIt.instance<NotificationBadgeController>();
    _badgeController.addListener(_onBadgeChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _badgeController.loadUnreadCount();
    });
  }

  @override
  void dispose() {
    _badgeController.removeListener(_onBadgeChanged);
    super.dispose();
  }

  void _onBadgeChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onMenuPressed,
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.verdeDestaque,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.background,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.greeting,
                style: const TextStyle(
                  color: AppColors.cinzaClaro,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.userName,
                style: const TextStyle(
                  color: AppColors.branco,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              tooltip: 'Notificações',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.notifications);
              },
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.branco,
              ),
            ),
            if (_badgeController.unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _badgeController.unreadCount > 99
                        ? '99+'
                        : '${_badgeController.unreadCount}',
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 4),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onReload,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.verdeDestaque.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.refresh_rounded,
              color: AppColors.verdeDestaque,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

