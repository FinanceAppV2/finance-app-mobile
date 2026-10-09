import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ExpensesHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback? onFilter;

  const ExpensesHeader({
    super.key,
    required this.title,
    required this.count,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.marfim,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          '$count itens',
          style: TextStyle(
            color: AppColors.cinza.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        if (onFilter != null) ...[
          const SizedBox(width: 4),
          IconButton(
            onPressed: onFilter,
            icon: Icon(
              Icons.filter_list_rounded,
              color: AppColors.cinza,
              size: 20,
            ),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
        ],
      ],
    );
  }
}
