import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/chart_highest_month.dart';
import 'section_card.dart';

class HighestMonthCard extends StatelessWidget {
  final ChartHighestMonth data;

  const HighestMonthCard({super.key, required this.data});

  static const _monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  @override
  Widget build(BuildContext context) {
    final formatted = data.total.toStringAsFixed(2).replaceAll('.', ',');
    final monthIndex = (data.month - 1).clamp(0, 11);
    return SectionCard(
      title: 'Mês de Maior Gasto',
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
          const SizedBox(width: 10),
          Text(
            '${_monthNames[monthIndex]}/${data.year}',
            style: const TextStyle(
              color: AppColors.marfim,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            'R\$ $formatted',
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
