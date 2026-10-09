import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/chart_top_expense.dart';
import 'section_card.dart';

class TopExpensesCard extends StatelessWidget {
  final List<ChartTopExpense> data;

  const TopExpensesCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Maiores Despesas',
      child: Column(
        children: data.map((e) {
          final formatted = e.value.toStringAsFixed(2).replaceAll('.', ',');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.marfim, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'R\$ $formatted',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
