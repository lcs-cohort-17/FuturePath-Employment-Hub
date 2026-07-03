import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/screens/profile/track_applications_screen.dart';

void main() {
  // Mock data representing historical application tracking list inputs
  final mockApplications = [
    {
      'title': 'Junior Flutter Developer',
      'company': 'TechNova Solutions',
      'status': 'Accepted',
      'progress': 100,
    },
    {
      'title': 'Cloud Architecture Intern',
      'company': 'Apex Systems',
      'status': 'Under Review',
      'progress': 65,
    },
  ];

  group('TrackApplicationsScreen UI and Interactivity Tests', () {
    testWidgets('Should display empty placeholder text when list is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TrackApplicationsScreen(applications: []),
        ),
      );

      expect(find.text("No active applications."), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('Should render application cards with correct titles and company names', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TrackApplicationsScreen(applications: mockApplications),
        ),
      );

      // Verify header info
      expect(find.text('Track Applications'), findsOneWidget);

      // Verify job items show up cleanly
      expect(find.text('Junior Flutter Developer'), findsOneWidget);
      expect(find.text('TechNova Solutions'), findsOneWidget);
      expect(find.text('Cloud Architecture Intern'), findsOneWidget);
    });

    testWidgets('Tapping a card should expand it and reveal progress indicators', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TrackApplicationsScreen(applications: mockApplications),
        ),
      );

      // Ensure progress bar and remove button are hidden on init execution
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.text('Remove application'), findsNothing);

      // Tap first listing item card
      await tester.tap(find.text('Junior Flutter Developer'));
      await tester.pumpAndSettle();

      // Verify the details container section has unrolled safely
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Remove application'), findsOneWidget);
    });

    testWidgets('Clicking remove should show dialog box confirmation framework', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TrackApplicationsScreen(applications: mockApplications),
        ),
      );

      // Expand the item to find the remove option target
      await tester.tap(find.text('Junior Flutter Developer'));
      await tester.pumpAndSettle();

      // Trigger the modal target context
      await tester.tap(find.text('Remove application'));
      await tester.pumpAndSettle();

      // Verify confirmation dialogue prompts show up cleanly on screen boundaries
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Remove Application'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}