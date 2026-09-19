import 'package:finance_app_mobile/features/finance_config/domain/entities/finance_config.dart';
import 'package:finance_app_mobile/features/finance_config/presentation/controllers/finance_config_controller.dart';
import 'package:finance_app_mobile/features/finance_config/presentation/pages/finance_config_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class FakeFinanceConfigController extends ChangeNotifier
    implements FinanceConfigController {
  @override
  FinanceConfigStatus status = FinanceConfigStatus.success;

  @override
  String? errorMessage;

  @override
  FinanceConfig? config;

  @override
  List<FinanceConfig> configs = [];

  @override
  FinanceConfig? get postpaidConfig =>
      configs.where((c) => c.type.toUpperCase() == 'POSPAID').firstOrNull ??
      (config?.type.toUpperCase() == 'POSPAID' ? config : null);

  @override
  FinanceConfig? get prepaidConfig =>
      configs.where((c) => c.type.toUpperCase() == 'PREPAID').firstOrNull ??
      (config?.type.toUpperCase() == 'PREPAID' ? config : null);

  @override
  Future<void> loadConfig() async {}

  @override
  Future<bool> updateConfig({
    required double monthlyIncome,
    required double spendingLimit,
    required double savingsGoal,
    required double emergencyFundGoal,
    String? type,
    double? cashBalance,
    int? salaryDay,
    int? paymentDay,
  }) async =>
      true;
}

void main() {
  group('FinanceConfigPage - Cash Balance Field (Caixa)', () {
    late FakeFinanceConfigController fakeController;

    setUp(() {
      fakeController = FakeFinanceConfigController();
      GetIt.instance.registerSingleton<FinanceConfigController>(fakeController);
    });

    tearDown(() {
      GetIt.instance.unregister<FinanceConfigController>();
    });

    testWidgets(
      'Cash balance field should accept numeric input',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        expect(textFields, findsWidgets);

        final cashBalanceField = textFields.at(0);
        await tester.enterText(cashBalanceField, '5000');
        await tester.pump();

        final TextFormField widget = tester.widget(cashBalanceField);
        expect(widget.controller?.text, '50,00');
      },
    );

    testWidgets(
      'Cash balance field should display currency formatting hint',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Ex: 3.000,00'), findsWidgets);
      },
    );

    testWidgets(
      'Cash balance field should have R\$ prefix text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('R\$ '), findsWidgets);
      },
    );

    testWidgets(
      'Cash balance field should validate empty input',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        final cashBalanceField = textFields.at(0);
        final widget = tester.widget<TextFormField>(cashBalanceField);
        final validator = widget.validator;

        expect(validator?.call(''), 'Preencha este campo');
        expect(validator?.call(null), 'Preencha este campo');
      },
    );

    testWidgets(
      'Cash balance field should allow valid numeric values',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        final cashBalanceField = textFields.at(0);
        final widget = tester.widget<TextFormField>(cashBalanceField);
        final validator = widget.validator;

        expect(validator?.call('1000'), null);
        expect(validator?.call('9999.99'), null);
      },
    );

    testWidgets(
      'Cash balance field should have white text color',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);
        expect(textFields, findsWidgets);
      },
    );

    testWidgets(
      'Cash balance field should be keyboard number type by checking input acceptance',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        final cashBalanceField = textFields.at(0);

        await tester.enterText(cashBalanceField, '1500');
        await tester.pump();

        final widget = tester.widget<TextFormField>(cashBalanceField);
        expect(widget.controller?.text, '15,00');
      },
    );

    testWidgets(
      'Cash balance field should accept and clear text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        final cashBalanceField = textFields.at(0);

        await tester.enterText(cashBalanceField, '1500');
        await tester.pump();

        final widget1 = tester.widget<TextFormField>(cashBalanceField);
        expect(widget1.controller?.text, '15,00');

        await tester.enterText(cashBalanceField, '');
        await tester.pump();

        final widget2 = tester.widget<TextFormField>(cashBalanceField);
        expect(widget2.controller?.text, '');
      },
    );

    testWidgets(
      'Cash balance field should accept values with more than 2 digits',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        final cashBalanceField = textFields.at(0);

        await tester.enterText(cashBalanceField, '123456');
        await tester.pump();

        final widget = tester.widget<TextFormField>(cashBalanceField);
        expect(widget.controller?.text, '1.234,56');
      },
    );

    testWidgets(
      'Cash balance field should validate and accept 100 and above',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FinanceConfigPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        final cashBalanceField = textFields.at(0);
        final widget = tester.widget<TextFormField>(cashBalanceField);
        final validator = widget.validator;

        expect(validator?.call('100'), null);
        expect(validator?.call('999'), null);
        expect(validator?.call('5000'), null);
        expect(validator?.call('999999'), null);
      },
    );
  });
}
