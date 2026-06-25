import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';

void main() {
  testWidgets('LoginScreen loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}