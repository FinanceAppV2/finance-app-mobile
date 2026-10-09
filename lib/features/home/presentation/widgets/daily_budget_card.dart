import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/salary_cycle.dart';

enum _BudgetPeriod { daily, weekly }

class DailyBudgetCard extends StatefulWidget {
  final SalaryCycle cycle;

  const DailyBudgetCard({super.key, required this.cycle});

  @override
  State<DailyBudgetCard> createState() => _DailyBudgetCardState();
}

class _DailyBudgetCardState extends State<DailyBudgetCard> {
  _BudgetPeriod _period = _BudgetPeriod.daily;

  String _formatMoney(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final cycle = widget.cycle;
    final isDaily = _period == _BudgetPeriod.daily;
    final budgetValue = isDaily ? cycle.dailyBudget : cycle.weeklyBudget;
    final hasBudget = cycle.budgetRemaining > 0 && budgetValue > 0;
    final valueColor = hasBudget ? AppColors.verdeDestaque : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.verdeEscuro.withValues(alpha: 0.5),
        border: Border.all(color: AppColors.verdeMedio),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.wallet_rounded,
                    color: AppColors.verdeDestaque,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Posso gastar',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              _PeriodToggle(
                period: _period,
                onChanged: (value) => setState(() => _period = value),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: Column(
              children: [
                Text(
                  'R\$ ${_formatMoney(hasBudget ? budgetValue : 0)}',
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDaily ? 'por dia até o fim do ciclo' : 'por semana até o fim do ciclo',
                  style: TextStyle(
                    color: AppColors.cinzaClaro.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Restam ${cycle.daysRemainingInCycle} dia(s) no ciclo',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
              Text(
                'Meta de economia: R\$ ${_formatMoney(cycle.savingsGoalMonthly)}',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          if (!hasBudget) ...[
            const SizedBox(height: 8),
            Text(
              'Você já atingiu o limite saudável de gastos para este ciclo.',
              style: TextStyle(
                color: AppColors.error.withValues(alpha: 0.9),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PeriodToggle extends StatelessWidget {
  final _BudgetPeriod period;
  final ValueChanged<_BudgetPeriod> onChanged;

  const _PeriodToggle({required this.period, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.verdeMedio.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption('Dia', _BudgetPeriod.daily),
          _buildOption('Semana', _BudgetPeriod.weekly),
        ],
      ),
    );
  }

  Widget _buildOption(String label, _BudgetPeriod value) {
    final isSelected = period == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.verdeDestaque : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.background : AppColors.cinzaClaro,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
