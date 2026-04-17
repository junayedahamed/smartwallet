import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartwallet/pages/first_page.dart';

void main() {
  testWidgets('Onboarding page renders key fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FirstPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome to SmartWallet'), findsOneWidget);
    expect(find.text('Start Tracking'), findsOneWidget);
    expect(find.text('Initial balance'), findsOneWidget);
    expect(find.text('Daily need'), findsOneWidget);
  });

  testWidgets('Onboarding validates 200000 max balance',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FirstPage(),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Initial balance'),
      '200001',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Daily need'),
      '200',
    );

    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    expect(find.text('Maximum balance is 200000'), findsOneWidget);
  });
}
