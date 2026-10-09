import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/entities/salary_cycle.dart';
import 'section_card.dart';

class SalaryCycleHistoryCard extends StatelessWidget {
  final List<SalaryCycle> cycles;

  const SalaryCycleHistoryCard({super.key, required this.cycles});

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
    if (cycles.isEmpty) {
      return const SizedBox.shrink();
    }

    return SectionCard(
      title: 'Evolução por Ciclo Salarial',
      child: Column(
        children: cycles.map((cycle) {
          final statusColor = _getStatusColor(cycle.status);
          final statusText = _getStatusText(cycle.status);
          final committedFormatted =
              cycle.committed.toStringAsFixed(2).replaceAll('.', ',');
          final availableFormatted =
              cycle.available.toStringAsFixed(2).replaceAll('.', ',');
          final progress = cycle.committedPercentage;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.latao.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cycle.label,
                      style: const TextStyle(
                        color: AppColors.marfim,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comprometido: R\$ $committedFormatted',
                      style: TextStyle(
                        color: AppColors.cinza.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'Disponível: R\$ $availableFormatted',
                      style: TextStyle(
                        color: cycle.available >= 0
                            ? AppColors.lataoClaro
                            : AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: AppColors.linha,
                    valueColor: AlwaysStoppedAnimation(statusColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
