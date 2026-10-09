import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app_mobile/features/home/data/models/salary_cycle_model.dart';
import 'package:finance_app_mobile/features/home/domain/entities/salary_cycle.dart';

void main() {
  group('SalaryCycleModel', () {
    final json = {
      'startDate': '2026-02-05T00:00:00.000Z',
      'endDate': '2026-03-04T00:00:00.000Z',
      'label': '05/02 a 04/03',
      'monthlyIncome': 5000.0,
      'expenses': 1200.0,
      'fixedExpenses': 800.0,
      'installments': 300.0,
      'committed': 2300.0,
      'available': 1700.0,
      'healthyLimit': 3500.0,
      'spendingLimitMonthly': 4000.0,
      'savingsGoalMonthly': 1000.0,
      'salaryDay': 5,
      'paymentDay': 5,
      'status': 'GREEN',
      'budgetRemaining': 1200.0,
      'daysRemainingInCycle': 10,
      'dailyBudget': 120.0,
      'weeklyBudget': 840.0,
    };

    test('should correctly deserialize from json and map to entity', () {
      final model = SalaryCycleModel.fromJson(json);
      expect(model.label, '05/02 a 04/03');
      expect(model.monthlyIncome, 5000.0);
      expect(model.committed, 2300.0);
      expect(model.available, 1700.0);
      expect(model.status, 'GREEN');
      expect(model.budgetRemaining, 1200.0);
      expect(model.daysRemainingInCycle, 10);
      expect(model.dailyBudget, 120.0);
      expect(model.weeklyBudget, 840.0);

      final entity = model.toEntity();
      expect(entity.status, SalaryCycleStatus.green);
      expect(entity.committedPercentage, closeTo(2300.0 / 4000.0, 0.001));
      expect(entity.dailyBudget, 120.0);
      expect(entity.weeklyBudget, 840.0);
      expect(entity.daysRemainingInCycle, 10);
      expect(entity.budgetRemaining, 1200.0);
    });

    test('should parse YELLOW and RED status correctly', () {
      final yellowModel = SalaryCycleModel.fromJson({...json, 'status': 'YELLOW'});
      expect(yellowModel.toEntity().status, SalaryCycleStatus.yellow);

      final redModel = SalaryCycleModel.fromJson({...json, 'status': 'RED'});
      expect(redModel.toEntity().status, SalaryCycleStatus.red);
    });

    test('should default budget fields to zero when missing from json', () {
      final legacyJson = {...json}
        ..remove('budgetRemaining')
        ..remove('daysRemainingInCycle')
        ..remove('dailyBudget')
        ..remove('weeklyBudget');

      final model = SalaryCycleModel.fromJson(legacyJson);
      expect(model.budgetRemaining, 0.0);
      expect(model.daysRemainingInCycle, 0);
      expect(model.dailyBudget, 0.0);
      expect(model.weeklyBudget, 0.0);
    });
  });
}
