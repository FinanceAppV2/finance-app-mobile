import 'package:finance_app_mobile/core/formatters/currency_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const formatter = CurrencyInputFormatter();

  group('CurrencyInputFormatter', () {
    test('formats typed digits as Brazilian currency', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '123456'),
      );

      expect(result.text, '1.234,56');
      expect(result.selection.baseOffset, result.text.length);
    });

    test('does not preserve leading zeros while typing', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '0,00'),
        const TextEditingValue(text: '0,004'),
      );

      expect(result.text, '0,04');
    });

    test('formats monetary values for existing records', () {
      expect(CurrencyInputFormatter.format(5000), '5.000,00');
      expect(CurrencyInputFormatter.format(12.5), '12,50');
    });

    test('parses formatted currency to a decimal value', () {
      expect(CurrencyInputFormatter.parse('1.234,56'), 1234.56);
      expect(CurrencyInputFormatter.parse('R\$ 0,01'), 0.01);
    });
  });
}
