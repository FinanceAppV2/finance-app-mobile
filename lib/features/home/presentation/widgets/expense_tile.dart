import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseTile({super.key, required this.expense});

  static const _categoryColors = <String, Color>{
    'Alimentação': Color(0xFFFF7043),
    'Transporte': Color(0xFF42A5F5),
    'Saúde': Color(0xFFEF5350),
    'Moradia': Color(0xFFAB47BC),
    'Assinatura': Color(0xFF26C6DA),
    'Lazer': Color(0xFF66BB6A),
    'Educação': Color(0xFFFFA726),
  };

  @override
  Widget build(BuildContext context) {
    final color = _categoryColors[expense.category] ?? AppColors.cinzaClaro;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cinzaEscuro, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              _categoryIcon(expense.category),
              color: AppColors.branco,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  expense.category.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.cinzaClaro.withValues(alpha: 0.85),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '- R\$ ${expense.value.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(
                  color: AppColors.branco,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.south_east_rounded,
                    color: AppColors.error,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    _formatDate(expense.date),
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Alimentação':
        return Icons.restaurant_rounded;
      case 'Assinatura':
        return Icons.play_arrow_rounded;
      case 'Transporte':
        return Icons.directions_car_rounded;
      case 'Saúde':
        return Icons.favorite_rounded;
      case 'Moradia':
        return Icons.home_rounded;
      case 'Lazer':
        return Icons.movie_rounded;
      case 'Educação':
        return Icons.menu_book_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}';
  }
}
