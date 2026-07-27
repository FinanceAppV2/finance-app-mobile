import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  const CurrencyInputFormatter();

  static double parse(String text) {
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');
    final cents = int.tryParse(digits);
    return cents == null ? 0 : cents / 100;
  }

  static String format(double value) {
    final cents = (value * 100).round();
    return _formatDigits(cents.toString());
  }

  static String _formatDigits(String digits) {
    final normalizedDigits = digits.replaceFirst(RegExp(r'^0+'), '');
    final paddedDigits = (normalizedDigits.isEmpty ? '0' : normalizedDigits)
        .padLeft(3, '0');
    final integerDigits = paddedDigits.substring(0, paddedDigits.length - 2);
    final decimalDigits = paddedDigits.substring(paddedDigits.length - 2);
    final formattedInteger = integerDigits.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return '$formattedInteger,$decimalDigits';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return const TextEditingValue();

    final formatted = _formatDigits(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
