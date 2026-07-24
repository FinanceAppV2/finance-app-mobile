import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class FixedExpensesPage extends StatelessWidget {
  const FixedExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 64,
                color: AppColors.verdeDestaque.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Despesas Fixas',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nenhuma despesa fixa cadastrada',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}