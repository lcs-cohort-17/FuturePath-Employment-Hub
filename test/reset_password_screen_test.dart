import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:futurepath_employment_hub/screens/auth/reset_password_screen.dart';

void main() {
  testWidgets('ResetPasswordScreen loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ResetPasswordScreen(),
      ),
    );

    expect(find.byType(ResetPasswordScreen), findsOneWidget);
  });
}