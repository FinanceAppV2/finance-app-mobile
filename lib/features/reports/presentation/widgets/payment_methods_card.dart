import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/chart_payment_method.dart';
import 'section_card.dart';

class PaymentMethodsCard extends StatelessWidget {
  final List<ChartPaymentMethod> data;

  const PaymentMethodsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Gastos por Pagamento',
      child: Column(
        children: data.map((p) {
          final formatted = p.total.toStringAsFixed(2).replaceAll('.', ',');
          final pct = p.percentage.toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    p.paymentMethod,
                    style: const TextStyle(color: AppColors.marfim, fontSize: 13),
                  ),
                ),
                Text(
                  'R\$ $formatted',
                  style: const TextStyle(color: AppColors.cinza, fontSize: 12),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 40,
                  child: Text(
                    '$pct%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.lataoClaro,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
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
