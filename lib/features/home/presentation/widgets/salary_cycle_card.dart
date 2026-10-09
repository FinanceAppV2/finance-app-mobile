import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/salary_cycle.dart';

class SalaryCycleCard extends StatelessWidget {
  final SalaryCycle cycle;

  const SalaryCycleCard({super.key, required this.cycle});

  Color _getStatusColor(SalaryCycleStatus status) {
    switch (status) {
      case SalaryCycleStatus.green:
        return AppColors.lataoClaro;
      case SalaryCycleStatus.yellow:
        return AppColors.warning;
      case SalaryCycleStatus.red:
        return AppColors.error;
    }
  }

  String _getStatusText(SalaryCycleStatus status) {
    switch (status) {
      case SalaryCycleStatus.green:
        return 'Saudável';
      case SalaryCycleStatus.yellow:
        return 'Atenção';
      case SalaryCycleStatus.red:
        return 'Crítico';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(cycle.status);
    final statusText = _getStatusText(cycle.status);
    final committedFormatted = cycle.committed.toStringAsFixed(2).replaceAll('.', ',');
    final availableFormatted = cycle.available.toStringAsFixed(2).replaceAll('.', ',');
    final incomeFormatted = cycle.monthlyIncome.toStringAsFixed(2).replaceAll('.', ',');
    final progress = cycle.committedPercentage;
    final percentage = (progress * 100).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.superficie, AppColors.background],
        ),
        border: Border.all(color: AppColors.latao),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.event_repeat_rounded,
                    color: AppColors.lataoClaro,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ciclo: ${cycle.label}',
                    style: const TextStyle(
                      color: AppColors.marfim,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.latao.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comprometido',
                        style: TextStyle(
                          color: AppColors.cinza.withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ $committedFormatted',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.latao.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disponível',
                        style: TextStyle(
                          color: AppColors.cinza.withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ $availableFormatted',
                        style: TextStyle(
                          color: cycle.available >= 0
                              ? AppColors.lataoClaro
                              : AppColors.error,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.linha,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uso do teto: $percentage%',
                style: TextStyle(
                  color: AppColors.cinza.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
              Text(
                'Renda base: R\$ $incomeFormatted',
                style: TextStyle(
                  color: AppColors.cinza.withValues(alpha: 0.7),
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
