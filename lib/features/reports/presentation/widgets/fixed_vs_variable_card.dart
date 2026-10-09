import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/chart_fixed_vs_variable.dart';
import 'section_card.dart';

class FixedVsVariableCard extends StatelessWidget {
  final ChartFixedVsVariable data;

  const FixedVsVariableCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Fixas vs Variáveis',
      child: Column(
        children: [
          _ProgressRow(
            label: 'Fixas',
            value: data.fixedTotal,
            percentage: data.fixedPercentage,
            color: AppColors.lataoClaro,
          ),
          const SizedBox(height: 8),
          _ProgressRow(
            label: 'Variáveis',
            value: data.variableTotal,
            percentage: data.variablePercentage,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final double percentage;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    final pct = percentage.toStringAsFixed(0);
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.marfim, fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 10,
              backgroundColor: AppColors.linha,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            'R\$ $formatted ($pct%)',
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.cinza, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
