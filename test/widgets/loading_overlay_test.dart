import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:futurepath_employment_hub/widgets/loading_overlay.dart';

void main() {
  testWidgets(
    'LoadingOverlay displays CircularProgressIndicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(),
          ),
        ),
      );

      expect(
        find.byType(
          CircularProgressIndicator,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'LoadingOverlay contains Center widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(),
          ),
        ),
      );

      expect(
        find.byType(Center),
        findsOneWidget,
      );
    },
  );
}