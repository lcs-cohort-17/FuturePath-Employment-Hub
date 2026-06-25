import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:futurepath_employment_hub/screens/auth/app_gate.dart';

void main() {
  testWidgets('AppGate widget loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppGate(),
      ),
    );

    expect(find.byType(AppGate), findsOneWidget);
  });
}