import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

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
                Icons.pie_chart_rounded,
                size: 64,
                color: AppColors.verdeDestaque.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Relatórios',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Em breve',
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