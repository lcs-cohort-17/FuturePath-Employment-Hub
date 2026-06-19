import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_list_screen.dart';

void main() {
  group('UIUX-014: Location Filter', () {

    testWidgets('Location filter chips are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.text('All Locations'), findsOneWidget);
      expect(find.text('Cape Town'), findsWidgets);
      expect(find.text('Johannesburg'), findsWidgets);
      expect(find.text('Durban'), findsWidgets);
      expect(find.text('Remote'), findsWidgets);
    });

    testWidgets('Location filter reduces opportunity count', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.text('2 opportunities found'), findsOneWidget);

      await tester.tap(find.text('Cape Town').first);
      await tester.pumpAndSettle();

      expect(find.text('1 opportunity found'), findsOneWidget);
    });

    testWidgets('All Locations shows all opportunities', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      await tester.tap(find.text('Cape Town').first);
      await tester.pumpAndSettle();
      expect(find.text('1 opportunity found'), findsOneWidget);

      await tester.tap(find.text('All Locations'));
      await tester.pumpAndSettle();
      expect(find.text('2 opportunities found'), findsOneWidget);
    });

    testWidgets('Johannesburg filter works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      await tester.tap(find.text('Johannesburg').first);
      await tester.pumpAndSettle();

      expect(find.text('1 opportunity found'), findsOneWidget);
    });

    testWidgets('Location filter works with skill filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      await tester.tap(find.text('Cape Town').first);
      await tester.pumpAndSettle();
      expect(find.text('1 opportunity found'), findsOneWidget);

      await tester.tap(find.text('Flutter').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('opportunity found'), findsOneWidget);
    });
  });
}