import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/chart_monthly_trend.dart';
import 'section_card.dart';

class MonthlyTrendCard extends StatelessWidget {
  final List<ChartMonthlyTrend> data;

  const MonthlyTrendCard({super.key, required this.data});

  static const _monthNames = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  @override
  Widget build(BuildContext context) {
    final maxTotal = data.fold<double>(0, (max, d) => d.total > max ? d.total : max);
    final maxBar = maxTotal > 0 ? maxTotal : 1;

    return SectionCard(
      title: 'Evolução Mensal',
      child: Column(
        children: data.map((d) {
          final fraction = d.total / maxBar;
          final formatted = d.total.toStringAsFixed(2).replaceAll('.', ',');
          final monthIndex = (d.month - 1).clamp(0, 11);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    _monthNames[monthIndex],
                    style: const TextStyle(color: AppColors.cinzaClaro, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 8,
                      backgroundColor: AppColors.cinzaEscuro,
                      valueColor: const AlwaysStoppedAnimation(AppColors.verdeMedio),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: Text(
                    'R\$ $formatted',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.cinzaClaro, fontSize: 10),
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
