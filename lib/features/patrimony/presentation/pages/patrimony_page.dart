import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PatrimonyPage extends StatelessWidget {
  const PatrimonyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Patrimônios'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_rounded,
              size: 64,
              color: AppColors.verdeDestaque.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Em breve',
              style: TextStyle(
                color: AppColors.cinzaClaro,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A funcionalidade de patrimônios\nestá sendo desenvolvida.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
