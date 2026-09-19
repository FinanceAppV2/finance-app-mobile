import 'package:finance_app_mobile/core/formatters/currency_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const formatter = CurrencyInputFormatter();

  group('CurrencyInputFormatter', () {
    test('clears when deleting 0,00', () {
      var current = const TextEditingValue(
        text: '0,00',
        selection: TextSelection.collapsed(offset: 4),
      );
      var next = const TextEditingValue(
        text: '0,0',
        selection: TextSelection.collapsed(offset: 3),
      );
      current = formatter.formatEditUpdate(current, next);
      expect(current.text, '');
    });

    test('simulates sequential typing on mobile with existing text', () {
      var current = const TextEditingValue(
        text: '3.000,00',
        selection: TextSelection.collapsed(offset: 8),
      );

      var next = const TextEditingValue(
        text: '3.000,0',
        selection: TextSelection.collapsed(offset: 7),
      );
      current = formatter.formatEditUpdate(current, next);
      expect(current.text, '300,00');

      next = const TextEditingValue(
        text: '300,005',
        selection: TextSelection.collapsed(offset: 7),
      );
      current = formatter.formatEditUpdate(current, next);
      expect(current.text, '3.000,05');
    });

    test('simulates typing from empty', () {
      var current = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );

      var next = const TextEditingValue(
        text: '5',
        selection: TextSelection.collapsed(offset: 1),
      );
      current = formatter.formatEditUpdate(current, next);
      expect(current.text, '0,05');

      next = const TextEditingValue(
        text: '0,050',
        selection: TextSelection.collapsed(offset: 5),
      );
      current = formatter.formatEditUpdate(current, next);
      expect(current.text, '0,50');
    });

    test('formats monetary values for existing records', () {
      expect(CurrencyInputFormatter.format(5000), '5.000,00');
      expect(CurrencyInputFormatter.format(12.5), '12,50');
    });

    test('parses formatted currency to a decimal value', () {
      expect(CurrencyInputFormatter.parse('1.234,56'), 1234.56);
      expect(CurrencyInputFormatter.parse('R\$ 0,01'), 0.01);
      expect(CurrencyInputFormatter.parse(''), 0.0);
    });
  });
}
