import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/monthly_summary.dart';

class SummaryCard extends StatelessWidget {
  final MonthlySummary summary;

  const SummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final used = summary.totalOutgoing;
    final limit = summary.spendingLimitMonthly;
    final progress = limit <= 0 ? 0.0 : (used / limit).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.superficie, AppColors.background],
        ),
        border: Border.all(color: AppColors.latao),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _MainInfo(
                    label: 'Renda',
                    value: summary.monthlyIncome,
                    color: AppColors.lataoClaro,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showInfoPopup(context, 'Balanço',
                        'Valor restante após somar todas as despesas do mês (incluindo despesas fixas) e subtrair da renda mensal.'),
                    child: _MainInfo(
                      label: 'Balanço',
                      value: summary.remaining,
                      color: summary.remaining >= 0
                          ? AppColors.lataoClaro
                          : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SavingsProgress(
              limit: limit,
              progress: progress,
              percentage: percentage,
              used: used,
            ),
          ],
        ),
      ),
    );
  }
}

class _MainInfo extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MainInfo({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.cinza.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'R\$ $formatted',
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsProgress extends StatelessWidget {
  final double limit;
  final double progress;
  final int percentage;
  final double used;

  const _SavingsProgress({
    required this.limit,
    required this.progress,
    required this.percentage,
    required this.used,
  });

  @override
  Widget build(BuildContext context) {
    final limitFormatted = limit.toStringAsFixed(2).replaceAll('.', ',');
    final usedFormatted = used.toStringAsFixed(2).replaceAll('.', ',');
    final remaining = (limit - used).clamp(0.0, limit);
    final remainingFormatted = remaining.toStringAsFixed(2).replaceAll('.', ',');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.latao,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Limite de gastos',
                    style: TextStyle(
                      color: AppColors.cinza.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: progress >= 0.8 ? AppColors.warning : AppColors.lataoClaro,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.linha,
              valueColor: AlwaysStoppedAnimation(
                progress >= 0.8 ? AppColors.warning : AppColors.lataoClaro,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  'Gasto: R\$ $usedFormatted',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.cinza.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                  onTap: () => _showInfoPopup(context, 'Restante',
                      'Valor que ainda pode ser gasto dentro do limite mensal definido.'),
                  child: Text(
                    'Restante: R\$ $remainingFormatted',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColors.cinza.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Limite: R\$ $limitFormatted',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.cinza.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showInfoPopup(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.superficie,
      title: Text(title, style: const TextStyle(color: AppColors.marfim)),
      content: Text(message, style: const TextStyle(color: AppColors.cinza)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK', style: TextStyle(color: AppColors.lataoClaro)),
        ),
      ],
    ),
  );
}