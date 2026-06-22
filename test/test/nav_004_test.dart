import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/screens/shell/main_shell.dart';

void main() {
  group('NAV-004 Cross-Tab Navigation Integration Tests', () {

    testWidgets('Tapping a Programme result switches tab and pushes details screen',
            (WidgetTester tester) async {
          // 1. Inflate the application shell structure
          await tester.pumpWidget(
            MaterialApp(
              // IMPORTANT: Must pass the shellKey so the app can find MainShellState
              home: MainShell(key: MainShell.shellKey),
            ),
          );

          // Verify we start on the Home Screen tab
          expect(find.text('Open Search Results'), findsOneWidget);

          // 2. Open the Search Results Screen overlay
          await tester.tap(find.text('Open Search Results'));
          await tester.pumpAndSettle();

          // Verify Search Results Screen is open
          expect(find.text('Search Results'), findsOneWidget);
          expect(find.text('Software Development Programme'), findsOneWidget);

          // 3. Tap the Programme item
          await tester.tap(find.text('Software Development Programme'));

          // Pump to trigger the pop and the tab switch
          await tester.pump();
          // Pump again to trigger the addPostFrameCallback push
          await tester.pumpAndSettle();

          // ACCEPTANCE CRITERIA CHECK: Verify Details Screen is pushed
          expect(find.text('Details'), findsOneWidget);
          expect(find.text('Software Development Programme'), findsOneWidget);

          // 4. Simulate hitting the back button
          await tester.pageBack();
          await tester.pumpAndSettle();

          // ACCEPTANCE CRITERIA CHECK: Should be back at Programmes Tab
          expect(find.text('Programmes Screen List View'), findsOneWidget);
          expect(find.text('Search Results'), findsNothing);
        });

    testWidgets('Tapping a Job result switches tab and pushes details screen',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: MainShell(key: MainShell.shellKey),
            ),
          );

          await tester.tap(find.text('Open Search Results'));
          await tester.pumpAndSettle();

          expect(find.text('Junior Flutter Developer'), findsOneWidget);
          await tester.tap(find.text('Junior Flutter Developer'));

          await tester.pump();
          await tester.pumpAndSettle();

          expect(find.text('Details'), findsOneWidget);
          expect(find.text('Junior Flutter Developer'), findsOneWidget);

          await tester.pageBack();
          await tester.pumpAndSettle();

          expect(find.text('Jobs Screen List View'), findsOneWidget);
          expect(find.text('Search Results'), findsNothing);
        });
  });
}