import 'package:flutter/material.dart';

import '../../core/formatters/currency_input_formatter.dart';
import '../../core/theme/app_theme.dart';

class MoneyInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onChanged;
  final bool readOnly;

  const MoneyInputField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.branco,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          autofocus: false,
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          inputFormatters: [const CurrencyInputFormatter()],
          style: const TextStyle(color: AppColors.branco, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Ex: 3.000,00',
            prefixText: 'R\$ ',
            filled: true,
            fillColor: AppColors.background.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.verdeDestaque.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.verdeDestaque.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.verdeDestaque,
              ),
            ),
          ),
          onChanged: (_) => onChanged?.call(),
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Preencha este campo';
                }
                return null;
              },
        ),
      ],
    );
  }
}

