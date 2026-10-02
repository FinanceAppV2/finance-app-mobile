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
    final paddedDigits = digits.padLeft(3, '0');
    final integerDigits = paddedDigits.substring(0, paddedDigits.length - 2);
    final decimalDigits = paddedDigits.substring(paddedDigits.length - 2);
    final normalizedInteger = integerDigits.replaceFirst(RegExp(r'^0+(?=\d)'), '') == '' ? '0' : integerDigits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final formattedInteger = normalizedInteger.replaceAllMapped(
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
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
        composing: TextRange.empty,
      );
    }

    final isDeleting = oldValue.text.length > newValue.text.length;
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.isEmpty || (isDeleting && (int.tryParse(digits) ?? 0) == 0)) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
        composing: TextRange.empty,
      );
    }

    final cleanDigits = digits.length > 12 ? digits.substring(0, 12) : digits;
    final formatted = _formatDigits(cleanDigits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
      composing: TextRange.empty,
    );
  }
}
