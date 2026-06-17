import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_list_screen.dart';

void main() {
  group('OpportunityListScreen Widget Tests', () {
    testWidgets('Displays search bar with correct hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.text('Search jobs, companies, skills...'), findsOneWidget);
    });

    testWidgets('Displays "opportunities found" count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.textContaining('opportunities found'), findsOneWidget);
    });

    testWidgets('Displays skill filter chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Flutter'), findsWidgets);
      expect(find.text('Python'), findsWidgets);
      expect(find.text('SQL'), findsWidgets);
      expect(find.text('Salesforce'), findsWidgets);
      expect(find.text('Digital Marketing'), findsOneWidget);
    });

    testWidgets('Displays job type filter chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.text('All Types'), findsOneWidget);
      expect(find.text('Full-time'), findsWidgets);
      expect(find.text('Part-time'), findsOneWidget);
      expect(find.text('Internship'), findsWidgets);
      expect(find.text('Learnership'), findsOneWidget);
    });

    testWidgets('Displays location filter chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.text('All Locations'), findsOneWidget);
      expect(find.text('Cape Town'), findsWidgets);
      expect(find.text('Johannesburg'), findsWidgets);
      expect(find.text('Durban'), findsOneWidget);
      expect(find.text('Remote'), findsOneWidget);
    });

    testWidgets('Displays sort chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      expect(find.text('Most Relevant'), findsOneWidget);
      expect(find.text('Closing Date'), findsOneWidget);
      expect(find.text('Salary (Highest First)'), findsOneWidget);
      expect(find.text('Newest'), findsOneWidget);
    });

    testWidgets('Tapping a card navigates to detail screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final cardTitle = find.text('Junior Flutter Developer');
      expect(cardTitle, findsOneWidget);

      await tester.tap(cardTitle);
      await tester.pumpAndSettle();

      expect(find.text('Job Details'), findsOneWidget);
    });

    testWidgets('Tapping employer name shows placeholder screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final companyName = find.text('TechNova Solutions');
      expect(companyName, findsOneWidget);

      await tester.tap(companyName);
      await tester.pumpAndSettle();

      expect(find.text('Employer Detail Screen - coming soon'), findsOneWidget);
    });

    testWidgets('Filter chips update the list - tapping Python removes Flutter job', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Junior Flutter Developer'), findsOneWidget);

      final pythonChip = find.text('Python');
      await tester.tap(pythonChip);
      await tester.pumpAndSettle();

      expect(find.text('Junior Flutter Developer'), findsNothing);
    });

    testWidgets('Pull-to-refresh indicator exists', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpportunityListScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final listFinder = find.byType(CustomScrollView);
      expect(listFinder, findsOneWidget);
    });
  });
}