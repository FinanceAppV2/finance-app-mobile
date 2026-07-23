import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final String greeting;
  final String userName;
  final VoidCallback? onMenuPressed;

  const HomeHeader({
    super.key,
    required this.greeting,
    required this.userName,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onMenuPressed,
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
                greeting,
                style: const TextStyle(
                  color: AppColors.cinzaClaro,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: const TextStyle(
                  color: AppColors.branco,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notificações',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhuma nova notificação.')),
          ),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.branco,
          ),
        ),
      ],
    );
  }
}
