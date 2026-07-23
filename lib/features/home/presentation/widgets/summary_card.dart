import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/monthly_summary_model.dart';

class SummaryCard extends StatelessWidget {
  final MonthlySummaryModel summary;

  const SummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final spendingProgress = summary.monthlyIncome == 0
        ? 0.0
        : (summary.totalOutgoing / summary.monthlyIncome).clamp(0.0, 1.0);
    final percentage = (spendingProgress * 100).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.verdeEscuro, AppColors.background],
        ),
        border: Border.all(color: AppColors.verdeMedio),
        boxShadow: const [
          BoxShadow(
            color: AppColors.background,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(summary.remaining),
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'JUL 2026',
                  style: TextStyle(
                    color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Info(
                  label: 'Receita',
                  value: summary.monthlyIncome,
                  color: AppColors.verdeDestaque,
                ),
                const SizedBox(width: 16),
                _Info(
                  label: 'Gasto',
                  value: summary.totalOutgoing,
                  color: AppColors.error,
                ),
                const SizedBox(width: 16),
                _Info(
                  label: 'Limite',
                  value: summary.spendingLimitMonthly,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: spendingProgress,
                minHeight: 4,
                backgroundColor: AppColors.cinzaEscuro,
                valueColor: const AlwaysStoppedAnimation(AppColors.verdeDestaque),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '$percentage% do limite usado',
                  style: TextStyle(
                    color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static String _format(double value) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $formatted';
  }
}

class _Info extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _Info({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.cinzaClaro.withValues(alpha: 0.7), fontSize: 11),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(
                color: AppColors.branco,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


