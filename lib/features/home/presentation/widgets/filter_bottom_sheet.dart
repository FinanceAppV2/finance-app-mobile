import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;
  final String? selectedCategory;
  final String? selectedPaymentMethod;

  const FilterBottomSheet({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    this.selectedCategory,
    this.selectedPaymentMethod,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late int _month;
  late int _year;
  String? _category;
  String? _paymentMethod;

  static const _monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  static const _categories = [
    {'value': 'FOOD', 'label': 'Alimentação', 'icon': Icons.restaurant_rounded},
    {'value': 'TRANSPORT', 'label': 'Transporte', 'icon': Icons.directions_car_rounded},
    {'value': 'HOUSING', 'label': 'Moradia', 'icon': Icons.home_rounded},
    {'value': 'HEALTH', 'label': 'Saúde', 'icon': Icons.favorite_rounded},
    {'value': 'EDUCATION', 'label': 'Educação', 'icon': Icons.menu_book_rounded},
    {'value': 'LEISURE', 'label': 'Lazer', 'icon': Icons.movie_rounded},
    {'value': 'CLOTHING', 'label': 'Vestuário', 'icon': Icons.checkroom_rounded},
    {'value': 'SERVICES', 'label': 'Serviços', 'icon': Icons.build_rounded},
    {'value': 'TAXES', 'label': 'Impostos', 'icon': Icons.receipt_rounded},
    {'value': 'INVESTMENTS', 'label': 'Investimentos', 'icon': Icons.trending_up_rounded},
    {'value': 'OTHERS', 'label': 'Outros', 'icon': Icons.more_horiz_rounded},
  ];

  static const _paymentMethods = [
    {'value': 'CREDIT_CARD', 'label': 'Crédito', 'icon': Icons.credit_card_rounded},
    {'value': 'DEBIT_CARD', 'label': 'Débito', 'icon': Icons.credit_card_outlined},
    {'value': 'PIX', 'label': 'Pix', 'icon': Icons.qr_code_rounded},
    {'value': 'MONEY', 'label': 'Dinheiro', 'icon': Icons.payments_rounded},
    {'value': 'TRANSFER', 'label': 'Transferência', 'icon': Icons.swap_horiz_rounded},
    {'value': 'BOLETO', 'label': 'Boleto', 'icon': Icons.receipt_long_rounded},
    {'value': 'OTHERS', 'label': 'Outros', 'icon': Icons.more_horiz_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _month = widget.selectedMonth;
    _year = widget.selectedYear;
    _category = widget.selectedCategory;
    _paymentMethod = widget.selectedPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - i);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.verdeEscuro,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtros',
                  style: TextStyle(
                    color: AppColors.branco,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text(
                    'Limpar',
                    style: TextStyle(color: AppColors.verdeDestaque),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Mês',
              style: TextStyle(
                color: AppColors.branco,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(12, (index) {
                final month = index + 1;
                final isSelected = month == _month;
                return GestureDetector(
                  onTap: () => setState(() => _month = month),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.verdeDestaque
                          : AppColors.verdeMedio.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _monthNames[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.background
                            : AppColors.cinzaClaro,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ano',
              style: TextStyle(
                color: AppColors.branco,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: years.map((year) {
                final isSelected = year == _year;
                return GestureDetector(
                  onTap: () => setState(() => _year = year),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.verdePrincipal
                          : AppColors.verdeMedio.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$year',
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.branco
                            : AppColors.cinzaClaro,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categoria',
              style: TextStyle(
                color: AppColors.branco,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = cat['value'] == _category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _category = isSelected ? null : cat['value'] as String;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.verdeDestaque
                          : AppColors.verdeMedio.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 16,
                          color: isSelected
                              ? AppColors.background
                              : AppColors.cinzaClaro,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat['label'] as String,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.background
                                : AppColors.cinzaClaro,
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Forma de pagamento',
              style: TextStyle(
                color: AppColors.branco,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _paymentMethods.map((method) {
                final isSelected = method['value'] == _paymentMethod;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _paymentMethod =
                          isSelected ? null : method['value'] as String;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.verdeDestaque
                          : AppColors.verdeMedio.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          method['icon'] as IconData,
                          size: 16,
                          color: isSelected
                              ? AppColors.background
                              : AppColors.cinzaClaro,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          method['label'] as String,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.background
                                : AppColors.cinzaClaro,
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(
                  context,
                  FilterResult(
                    month: _month,
                    year: _year,
                    category: _category,
                    paymentMethod: _paymentMethod,
                  ),
                ),
                child: const Text(
                  'Aplicar filtros',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _month = DateTime.now().month;
      _year = DateTime.now().year;
      _category = null;
      _paymentMethod = null;
    });
  }
}

class FilterResult {
  final int month;
  final int year;
  final String? category;
  final String? paymentMethod;

  const FilterResult({
    required this.month,
    required this.year,
    this.category,
    this.paymentMethod,
  });
}
