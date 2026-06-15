import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:futurepath_employment_hub/screens/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}