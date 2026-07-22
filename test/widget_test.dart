import 'package:flutter_test/flutter_test.dart';

import 'package:finance_app_mobile/main.dart';

void main() {
  testWidgets('App should render splash', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceApp());
    expect(find.text('Splash'), findsOneWidget);
  });
}
