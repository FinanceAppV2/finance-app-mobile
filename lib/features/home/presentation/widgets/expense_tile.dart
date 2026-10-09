import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/expense.dart';

class ExpenseTile extends StatefulWidget {
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

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  static const _categoryData = {
    'FOOD': {
      'label': 'Alimentação',
      'icon': Icons.restaurant_rounded,
      'color': 0xFFFF7043,
    },
    'TRANSPORT': {
      'label': 'Transporte',
      'icon': Icons.directions_car_rounded,
      'color': 0xFF42A5F5,
    },
    'HOUSING': {
      'label': 'Moradia',
      'icon': Icons.home_rounded,
      'color': 0xFFAB47BC,
    },
    'HEALTH': {
      'label': 'Saúde',
      'icon': Icons.favorite_rounded,
      'color': 0xFFEF5350,
    },
    'EDUCATION': {
      'label': 'Educação',
      'icon': Icons.menu_book_rounded,
      'color': 0xFFFFA726,
    },
    'LEISURE': {
      'label': 'Lazer',
      'icon': Icons.movie_rounded,
      'color': 0xFF66BB6A,
    },
    'CLOTHING': {
      'label': 'Vestuário',
      'icon': Icons.checkroom_rounded,
      'color': 0xFFEC407A,
    },
    'SERVICES': {
      'label': 'Serviços',
      'icon': Icons.build_rounded,
      'color': 0xFF78909C,
    },
    'TAXES': {
      'label': 'Impostos',
      'icon': Icons.receipt_rounded,
      'color': 0xFF8D6E63,
    },
    'INVESTMENTS': {
      'label': 'Investimentos',
      'icon': Icons.trending_up_rounded,
      'color': 0xFF26A69A,
    },
    'OTHERS': {
      'label': 'Outros',
      'icon': Icons.more_horiz_rounded,
      'color': 0xFF90A4AE,
    },
  };

  Map<String, dynamic> get _cat => _categoryData[widget.expense.category] ??
      {
        'label': widget.expense.category,
        'icon': Icons.receipt_long_rounded,
        'color': 0xFF90A4AE,
      };

  Color get _catColor => Color(_cat['color'] as int);

  String _paymentLabel(String method) {
    switch (method) {
      case 'CREDIT_CARD':
        return 'Crédito';
      case 'DEBIT_CARD':
        return 'Débito';
      case 'PIX':
        return 'Pix';
      case 'MONEY':
        return 'Dinheiro';
      case 'TRANSFER':
        return 'Transferência';
      case 'BOLETO':
        return 'Boleto';
      default:
        return 'Outros';
    }
  }

  IconData _paymentIcon(String method) {
    switch (method) {
      case 'CREDIT_CARD':
        return Icons.credit_card_rounded;
      case 'DEBIT_CARD':
        return Icons.credit_card_outlined;
      case 'PIX':
        return Icons.qr_code_rounded;
      case 'MONEY':
        return Icons.payments_rounded;
      case 'TRANSFER':
        return Icons.swap_horiz_rounded;
      case 'BOLETO':
        return Icons.receipt_long_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tile = FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.superficie.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.nevoa.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _catColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _cat['icon'] as IconData,
                                color: _catColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.expense.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.marfim,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        _cat['label'] as String,
                                        style: TextStyle(
                                          color: _catColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.nevoa.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _paymentIcon(
                                                  widget.expense.paymentMethod),
                                              color: AppColors.cinza,
                                              size: 9,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              _paymentLabel(
                                                  widget.expense.paymentMethod),
                                              style: const TextStyle(
                                                color: AppColors.cinza,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (widget.isFixed)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.lataoClaro
                                                .withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'FIXA',
                                            style: TextStyle(
                                              color: AppColors.lataoClaro,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '- R\$ ${widget.expense.value.toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: const TextStyle(
                                    color: AppColors.marfim,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      color: AppColors.cinza.withValues(alpha: 0.6),
                                      size: 10,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(widget.expense.date),
                                      style: TextStyle(
                                        color: AppColors.cinza.withValues(alpha: 0.6),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.onEdit == null && widget.onDelete == null) return tile;

    return Dismissible(
      key: ValueKey('expense_${widget.expense.id}'),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.latao, AppColors.latao],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_rounded, color: AppColors.marfim, size: 20),
            SizedBox(width: 8),
            Text(
              'Editar',
              style: TextStyle(
                color: AppColors.marfim,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.error.withValues(alpha: 0.7), AppColors.error],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_rounded, color: AppColors.marfim, size: 20),
            SizedBox(width: 8),
            Text(
              'Excluir',
              style: TextStyle(
                color: AppColors.marfim,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onEdit?.call();
        } else {
          widget.onDelete?.call();
        }
        return false;
      },
      child: tile,
    );
  }

  String _formatDate(String date) {
    final clean = date.contains('T') ? date.split('T')[0] : date;
    final parts = clean.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
