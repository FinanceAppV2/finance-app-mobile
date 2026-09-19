import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class DayInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onChanged;

  const DayInputField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
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
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.branco, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Dia do mês (1-31)',
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
                final day = int.tryParse(value);
                if (day == null || day < 1 || day > 31) {
                  return 'Dia inválido (1-31)';
                }
                return null;
              },
        ),
      ],
    );
  }
}
