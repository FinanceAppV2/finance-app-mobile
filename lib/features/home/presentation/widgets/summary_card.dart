import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/monthly_summary.dart';

class SummaryCard extends StatelessWidget {
  final MonthlySummary summary;

  const SummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final availableForSavings = summary.monthlyIncome - summary.totalOutgoing;
    final savingsProgress = summary.savingsGoalMonthly == 0
        ? 0.0
        : (availableForSavings / summary.savingsGoalMonthly).clamp(0.0, 1.0);
    final percentage = (savingsProgress * 100).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.verdeEscuro, AppColors.background],
        ),
        border: Border.all(color: AppColors.verdeMedio),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _MainInfo(
                    label: 'Renda',
                    value: summary.monthlyIncome,
                    color: AppColors.verdeDestaque,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MainInfo(
                    label: 'Balanço',
                    value: summary.remaining,
                    color: summary.remaining >= 0
                        ? AppColors.verdeDestaque
                        : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SavingsProgress(
              goal: summary.savingsGoalMonthly,
              progress: savingsProgress,
              percentage: percentage,
              available: availableForSavings,
            ),
          ],
        ),
      ),
    );
  }
}

class _MainInfo extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MainInfo({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.cinzaClaro.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'R\$ $formatted',
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsProgress extends StatelessWidget {
  final double goal;
  final double progress;
  final int percentage;
  final double available;

  const _SavingsProgress({
    required this.goal,
    required this.progress,
    required this.percentage,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    final goalFormatted = goal.toStringAsFixed(2).replaceAll('.', ',');
    final availableFormatted = available.toStringAsFixed(2).replaceAll('.', ',');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.savings_rounded,
                    color: AppColors.verdeMedio,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Meta de economia',
                    style: TextStyle(
                      color: AppColors.cinzaClaro.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: AppColors.verdeDestaque,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.cinzaEscuro,
              valueColor: const AlwaysStoppedAnimation(AppColors.verdeDestaque),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disponível: R\$ $availableFormatted',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
              Text(
                'Meta: R\$ $goalFormatted',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}