import 'package:finance_app_mobile/features/home/domain/entities/salary_cycle.dart';
import 'package:finance_app_mobile/features/home/presentation/widgets/daily_budget_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

SalaryCycle _buildCycle({
  double dailyBudget = 100.0,
  double weeklyBudget = 700.0,
  double budgetRemaining = 1000.0,
  int daysRemainingInCycle = 10,
}) {
  return SalaryCycle(
    startDate: DateTime(2026, 2, 5),
    endDate: DateTime(2026, 3, 4),
    label: '05/02 → 04/03',
    monthlyIncome: 5000.0,
    expenses: 1200.0,
    fixedExpenses: 800.0,
    installments: 300.0,
    committed: 2300.0,
    available: 1700.0,
    healthyLimit: 3500.0,
    spendingLimitMonthly: 4000.0,
    savingsGoalMonthly: 1000.0,
    salaryDay: 5,
    paymentDay: 5,
    status: SalaryCycleStatus.green,
    budgetRemaining: budgetRemaining,
    daysRemainingInCycle: daysRemainingInCycle,
    dailyBudget: dailyBudget,
    weeklyBudget: weeklyBudget,
  );
}

void main() {
  group('DailyBudgetCard', () {
    testWidgets('shows daily budget by default', (tester) async {
      final cycle = _buildCycle(dailyBudget: 120.5, weeklyBudget: 843.5);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DailyBudgetCard(cycle: cycle))),
      );

      expect(find.text('R\$ 120,50'), findsOneWidget);
      expect(find.text('por dia até o fim do ciclo'), findsOneWidget);
    });

    testWidgets('switches to weekly budget when "Semana" is tapped', (tester) async {
      final cycle = _buildCycle(dailyBudget: 120.5, weeklyBudget: 843.5);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DailyBudgetCard(cycle: cycle))),
      );

      await tester.tap(find.text('Semana'));
      await tester.pump();

      expect(find.text('R\$ 843,50'), findsOneWidget);
      expect(find.text('por semana até o fim do ciclo'), findsOneWidget);
    });

    testWidgets('shows zero and warning when budget is exhausted', (tester) async {
      final cycle = _buildCycle(
        dailyBudget: 0.0,
        weeklyBudget: 0.0,
        budgetRemaining: -50.0,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DailyBudgetCard(cycle: cycle))),
      );

      expect(find.text('R\$ 0,00'), findsOneWidget);
      expect(
        find.text('Você já atingiu o limite saudável de gastos para este ciclo.'),
        findsOneWidget,
      );
    });
  });
}
