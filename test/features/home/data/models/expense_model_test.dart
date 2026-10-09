import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app_mobile/features/home/data/models/expense_model.dart';

void main() {
  group('ExpenseModel', () {
    test('defaults type to EXPENSE and nullable fields to null', () {
      final model = ExpenseModel.fromJson({
        'id': 'exp-1',
        'description': 'Padaria',
        'value': 12.5,
        'category': 'FOOD',
        'paymentMethod': 'PIX',
        'date': '2026-10-01T00:00:00.000Z',
      });

      expect(model.type, 'EXPENSE');
      expect(model.cardId, isNull);
      expect(model.installments, isNull);
    });

    test('parses loan installment entries', () {
      final model = ExpenseModel.fromJson({
        'id': 'loan-1',
        'description': 'Empréstimo - parcela 2/12',
        'value': 450,
        'category': 'OTHERS',
        'paymentMethod': 'OTHERS',
        'cardId': null,
        'installments': 12,
        'type': 'LOAN_INSTALLMENT',
        'date': '2026-10-01T00:00:00.000Z',
      });

      expect(model.type, 'LOAN_INSTALLMENT');
      expect(model.installments, 12);
      expect(model.value, 450.0);
    });
  });
}
