import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final bool isFixed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    this.isFixed = false,
    this.onEdit,
    this.onDelete,
  });

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

    final tile = Container(
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
                  isFixed
                      ? '${expense.category.toUpperCase()} • FIXA'
                      : expense.category.toUpperCase(),
                  style: TextStyle(
                    color: isFixed
                        ? AppColors.verdeDestaque
                        : AppColors.cinzaClaro.withValues(alpha: 0.85),
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
                  Icon(
                    isFixed ? Icons.autorenew_rounded : Icons.south_east_rounded,
                    color: isFixed ? AppColors.verdeDestaque : AppColors.error,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    _formatDate(expense.date),
                    style: TextStyle(
                      color: isFixed ? AppColors.verdeDestaque : AppColors.error,
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

    if (isFixed) return tile;

    return Dismissible(
      key: ValueKey('expense_${expense.id}'),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.cinzaEscuro, width: 0.5),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_rounded, color: AppColors.branco, size: 20),
            SizedBox(width: 6),
            Text('Editar', style: TextStyle(color: AppColors.branco, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.cinzaEscuro, width: 0.5),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_rounded, color: AppColors.branco, size: 20),
            SizedBox(width: 6),
            Text('Excluir', style: TextStyle(color: AppColors.branco, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onEdit?.call();
        } else {
          onDelete?.call();
        }
        return false;
      },
      child: tile,
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
    final clean = date.contains('T') ? date.split('T')[0] : date;
    final parts = clean.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
