import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/chart_category.dart';
import 'section_card.dart';

class CategoriesCard extends StatelessWidget {
  final List<ChartCategory> data;

  const CategoriesCard({super.key, required this.data});

  static const _categoryColors = {
    'FOOD': Color(0xFFFF7043),
    'TRANSPORT': Color(0xFF42A5F5),
    'HOUSING': Color(0xFFAB47BC),
    'HEALTH': Color(0xFFEF5350),
    'EDUCATION': Color(0xFFFFA726),
    'LEISURE': Color(0xFF66BB6A),
    'CLOTHING': Color(0xFFEC407A),
    'SERVICES': Color(0xFF26C6DA),
    'TAXES': Color(0xFF8D6E63),
    'INVESTMENTS': Color(0xFF7E57C2),
    'OTHERS': Color(0xFF78909C),
  };

  @override
  Widget build(BuildContext context) {
    final maxTotal = data.fold<double>(0, (max, d) => d.total > max ? d.total : max);
    final maxBar = maxTotal > 0 ? maxTotal : 1;

    return SectionCard(
      title: 'Gastos por Categoria',
      child: Column(
        children: data.map((c) {
          final color = _categoryColors[c.category] ?? AppColors.cinza;
          final formatted = c.total.toStringAsFixed(2).replaceAll('.', ',');
          final pct = c.percentage.toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          c.category,
                          style: const TextStyle(color: AppColors.marfim, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      'R\$ $formatted ($pct%)',
                      style: const TextStyle(color: AppColors.cinza, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: c.total / maxBar,
                    minHeight: 6,
                    backgroundColor: AppColors.linha,
                    valueColor: AlwaysStoppedAnimation(color),
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
