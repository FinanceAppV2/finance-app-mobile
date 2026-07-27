import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/fixed_expense.dart';
import '../controllers/fixed_expenses_controller.dart';
import '../widgets/add_fixed_expense_sheet.dart';

class FixedExpensesPage extends StatefulWidget {
  const FixedExpensesPage({super.key});

  @override
  State<FixedExpensesPage> createState() => _FixedExpensesPageState();
}

class _FixedExpensesPageState extends State<FixedExpensesPage> {
  final _controller = GetIt.instance<FixedExpensesController>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    if (_controller.fixedExpenses.isEmpty) {
      _controller.loadFixedExpenses();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onAdd() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddFixedExpenseSheet(),
    ).then((result) {
      if (result == true) {
        _controller.loadFixedExpenses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 46, 24, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Despesas Fixas',
                  style: TextStyle(
                    color: AppColors.branco,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${_controller.fixedExpenses.length} itens',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: _onAdd,
                icon: const Icon(
                  Icons.add_rounded,
                  color: AppColors.verdeDestaque,
                  size: 22,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
            ],
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_controller.status == FixedExpensesStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.verdeDestaque),
      );
    }

    if (_controller.status == FixedExpensesStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage ?? 'Erro ao carregar dados',
              style: const TextStyle(color: AppColors.cinzaClaro),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.loadFixedExpenses(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_controller.fixedExpenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: AppColors.verdeDestaque.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma despesa fixa cadastrada',
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _controller.fixedExpenses.length,
      itemBuilder: (context, index) {
        final expense = _controller.fixedExpenses[index];
        return _FixedExpenseTile(expense: expense);
      },
    );
  }
}

class _FixedExpenseTile extends StatelessWidget {
  final FixedExpense expense;

  const _FixedExpenseTile({required this.expense});

  static const _categoryLabels = {
    'FOOD': 'Alimentação',
    'TRANSPORT': 'Transporte',
    'HOUSING': 'Moradia',
    'HEALTH': 'Saúde',
    'EDUCATION': 'Educação',
    'LEISURE': 'Lazer',
    'CLOTHING': 'Vestuário',
    'SERVICES': 'Serviços',
    'TAXES': 'Impostos',
    'INVESTMENTS': 'Investimentos',
    'OTHERS': 'Outros',
  };

  static const _categoryIcons = {
    'FOOD': Icons.restaurant_rounded,
    'TRANSPORT': Icons.directions_car_rounded,
    'HOUSING': Icons.home_rounded,
    'HEALTH': Icons.favorite_rounded,
    'EDUCATION': Icons.menu_book_rounded,
    'LEISURE': Icons.movie_rounded,
    'CLOTHING': Icons.checkroom_rounded,
    'SERVICES': Icons.build_rounded,
    'TAXES': Icons.receipt_rounded,
    'INVESTMENTS': Icons.trending_up_rounded,
    'OTHERS': Icons.more_horiz_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final valueFormatted = 'R\$ ${expense.value.toStringAsFixed(2).replaceAll('.', ',')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.verdeEscuro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.verdeMedio.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _categoryIcons[expense.category] ?? Icons.receipt_rounded,
              color: AppColors.verdeDestaque,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_categoryLabels[expense.category] ?? expense.category} • Dia ${expense.dueDay}',
                  style: TextStyle(
                    color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            valueFormatted,
            style: const TextStyle(
              color: AppColors.verdeDestaque,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
