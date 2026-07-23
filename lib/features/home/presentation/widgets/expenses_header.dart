import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ExpensesHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback? onSeeAll;

  const ExpensesHeader({
    super.key,
    required this.title,
    required this.count,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.branco,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          '$count itens',
          style: TextStyle(
            color: AppColors.cinzaClaro.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        if (onSeeAll != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'Ver todos',
              style: TextStyle(
                color: AppColors.verdeDestaque,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
