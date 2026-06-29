import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/main.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_list_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_detail_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/job_apply_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/job_apply_success_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/track_applications_screen.dart';
import 'package:futurepath_employment_hub/models/application.dart';

void main() {
  setUp(() {
    // Clear submitted applications before each test
    Application.submittedApplications.clear();
  });

  testWidgets('Full Job Application Flow Test', (WidgetTester tester) async {
    // 1. Start the app
    await tester.pumpWidget(const MyApp());
    expect(find.byType(OpportunityListScreen), findsOneWidget);

    // 2. Select a job opportunity
    await tester.tap(find.text('Software Engineer'));
    await tester.pumpAndSettle();

    // Acceptance Criteria: Tapping Apply Now on Job Details screen navigates to Apply screen.
    expect(find.byType(OpportunityDetailScreen), findsOneWidget);
    expect(find.text('Software Engineer'), findsAtLeastNWidgets(1));

    // 3. Tap "Apply Now"
    await tester.tap(find.text('Apply Now'));
    await tester.pumpAndSettle();

    // Acceptance Criteria: Apply screen receives job details automatically so fields can be pre-filled.
    expect(find.byType(JobApplyScreen), findsOneWidget);
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    final TextField textField = tester.widget(textFieldFinder);
    expect(textField.controller?.text, 'Software Engineer');

    // 4. Submit Application
    // Acceptance Criteria: On successful submission Apply screen navigates to Application Success screen.
    await tester.tap(find.text('Submit Application'));
    await tester.pumpAndSettle();

    expect(find.byType(JobApplySuccessScreen), findsOneWidget);

    // Acceptance Criteria: Apply screen is removed from stack after successful submission 
    // — back button on Success screen (or pop) goes to Job Details not Apply screen.
    // Tapping the 'Close' icon button on the Success screen should pop back to Details
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(OpportunityDetailScreen), findsOneWidget);
    expect(find.byType(JobApplyScreen), findsNothing);

    // 5. Verify the application appears in Track Applications
    // We are currently on OpportunityDetailScreen, we need to go back to Success to tap "Track Application"
    // or just trigger the navigation. Since we want to test the button on Success screen, let's re-apply.
    await tester.tap(find.text('Apply Now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit Application'));
    await tester.pumpAndSettle();

    // Acceptance Criteria: Tapping Track Application on Success screen navigates to Track Applications screen.
    await tester.tap(find.text('Track Application'));
    await tester.pumpAndSettle();

    expect(find.byType(TrackApplicationsScreen), findsOneWidget);

    // Acceptance Criteria: Track Applications screen shows the newly submitted application.
    // Note: It might find 2 if we applied twice in this test, so we check for at least one.
    expect(find.text('Software Engineer'), findsAtLeastNWidgets(1));
    expect(find.text('Pending'), findsAtLeastNWidgets(1));
  });
}
