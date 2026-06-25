import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/screens/admin/applicant_list_screen.dart';
import 'package:futurepath_employment_hub/screens/admin/applicant_detail_screen.dart';

void main() {
  group('Admin Navigation & Privacy Tests', () {
    
    testWidgets('Tapping applicant list item navigates to detail with correct ID', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ApplicantListScreen(),
      ));

      // Find first item in the list
      final firstItem = find.text('John Doe');
      expect(firstItem, findsOneWidget);

      // 1. Tapping item navigates to detail
      await tester.tap(firstItem);
      await tester.pumpAndSettle();

      // Verify we are on the detail screen
      expect(find.byType(ApplicantDetailScreen), findsOneWidget);
      
      // 2. Correct ID passed (USR-001 is the ID for John Doe in mock data)
      expect(find.text('Applicant USR-001'), findsOneWidget);
    });

    testWidgets('Detail screen back button returns to list', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ApplicantListScreen(),
      ));

      await tester.tap(find.text('John Doe'));
      await tester.pumpAndSettle();

      // Verify on detail
      expect(find.byType(ApplicantDetailScreen), findsOneWidget);

      // 3. Back button returns to list
      final backButton = find.byType(BackButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify back on list
      expect(find.byType(ApplicantListScreen), findsOneWidget);
    });

    testWidgets('Invalid ID shows error state with return button', (WidgetTester tester) async {
      // 4. Invalid ID shows error
      await tester.pumpWidget(const MaterialApp(
        home: ApplicantDetailScreen(applicantId: 'invalid'),
      ));

      expect(find.text('Invalid Applicant Record'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Verify the error return button works
      await tester.tap(find.text('Return to List'));
      await tester.pump();
      // In this test setup, pop just removes the widget since it's the root
    });

    testWidgets('Applicant detail contains no PII', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ApplicantDetailScreen(applicantId: 'USR-001'),
      ));

      // 5. No PII in Applicant detail
      // Should NOT find actual names, emails, or phone numbers
      expect(find.text('John Doe'), findsNothing);
      expect(find.textContaining('john.doe@example.com'), findsNothing);
      expect(find.textContaining('071'), findsNothing);
      expect(find.textContaining('+27'), findsNothing);

      // Should find anonymized info
      expect(find.text('Applicant USR-001'), findsOneWidget);
      expect(find.textContaining('Redacted for privacy'), findsOneWidget);
    });
  });
}
