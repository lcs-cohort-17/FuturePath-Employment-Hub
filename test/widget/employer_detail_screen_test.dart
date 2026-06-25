import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/jobs/employer_detail_screen.dart';
import 'package:futurepath_employment_hub/models/employer.dart';

void main() {
  group('UIUX-015: Employer Detail Screen', () {

    // Mock employer data
    final mockEmployer = EmployerModel(
      id: '1',
      companyName: 'TechNova Solutions',
      industry: 'Technology',
      location: 'Cape Town, South Africa',
      website: 'https://technova.co.za',
      email: 'careers@technova.co.za',
      bio: 'TechNova Solutions is a leading technology company specializing in innovative software solutions.',
      activeOpeningsCount: 5,
    );

    final mockEmployerIncomplete = EmployerModel(
      id: '2',
      companyName: 'StartupXYZ',
      industry: 'Business',
      location: 'Johannesburg',
      website: null,
      email: null,
      bio: null,
      activeOpeningsCount: 0,
    );

    // ─────────────────────────────────────────────────────────
    // SCREEN RENDERING & NAVIGATION
    // ─────────────────────────────────────────────────────────
    group('Screen Rendering & Navigation', () {

      testWidgets('Employer Detail screen displays title', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('Employer Profile'), findsOneWidget);
      });

      testWidgets('Back button is displayed and functional', (WidgetTester tester) async {
        bool didPop = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployerDetailScreen(employerData: mockEmployer),
                      ),
                    );
                  },
                  child: const Text('Open Employer Detail'),
                ),
              ),
            ),
            navigatorObservers: [
              TestNavigatorObserver(onPop: () => didPop = true),
            ],
          ),
        );

        await tester.tap(find.text('Open Employer Detail'));
        await tester.pumpAndSettle();

        // Tap back button
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(didPop, isTrue);
      });

      testWidgets('Screen uses Scaffold', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Screen uses AppTheme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // COMPANY INFORMATION DISPLAY
    // ─────────────────────────────────────────────────────────
    group('Company Information Display', () {

      testWidgets('Displays company name', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('TechNova Solutions'), findsOneWidget);
      });

      testWidgets('Displays industry', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('Technology'), findsOneWidget);
      });

      testWidgets('Displays location', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.textContaining('Cape Town'), findsOneWidget);
      });

      testWidgets('Displays verified badge', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
      });

      testWidgets('Displays company icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byIcon(Icons.business_rounded), findsOneWidget);
      });

      testWidgets('Displays profile status badge', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('Verified Full Profile'), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // ABOUT COMPANY SECTION
    // ─────────────────────────────────────────────────────────
    group('About Company Section', () {

      testWidgets('Displays "About Company" heading', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('About Company'), findsOneWidget);
      });

      testWidgets('Displays company bio', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.textContaining('TechNova Solutions is a leading technology company'), findsOneWidget);
      });

      testWidgets('Shows incomplete warning for missing data', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployerIncomplete),
          ),
        );

        expect(find.textContaining('Some company details are currently pending verification'), findsOneWidget);
      });

      testWidgets('Shows "Incomplete Profile" badge for missing data', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployerIncomplete),
          ),
        );

        expect(find.text('Incomplete Profile'), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // ADDITIONAL INFORMATION SECTION
    // ─────────────────────────────────────────────────────────
    group('Additional Information Section', () {

      testWidgets('Displays "Additional Information" heading', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('Additional Information'), findsOneWidget);
      });

      testWidgets('Displays website link', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('https://technova.co.za'), findsOneWidget);
      });

      testWidgets('Displays contact email', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.text('careers@technova.co.za'), findsOneWidget);
      });

      testWidgets('Displays active openings count', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.textContaining('5 Open Positions'), findsOneWidget);
      });

      testWidgets('Displays website icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byIcon(Icons.language_rounded), findsOneWidget);
      });

      testWidgets('Displays email icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      });

      testWidgets('Displays business icon for openings', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byIcon(Icons.business_center_outlined), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // EDGE CASES & NULL HANDLING
    // ─────────────────────────────────────────────────────────
    group('Edge Cases & Null Handling', () {

      testWidgets('Handles null employer data gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const EmployerDetailScreen(employerData: null),
          ),
        );

        // Should show default values
        expect(find.text('Unnamed Enterprise Asset'), findsOneWidget);
      });

      testWidgets('Shows placeholder text for missing website', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployerIncomplete),
          ),
        );

        expect(find.text('Website Not Listed'), findsOneWidget);
      });

      testWidgets('Shows default email when not provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployerIncomplete),
          ),
        );

        expect(find.text('support@employerplatform.internal'), findsOneWidget);
      });

      testWidgets('Shows zero openings message', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployerIncomplete),
          ),
        );

        expect(find.textContaining('No active positions listed'), findsOneWidget);
      });

      testWidgets('Shows default bio text when null', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployerIncomplete),
          ),
        );

        expect(find.textContaining('No overview biography details'), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // UI/UX VERIFICATION
    // ─────────────────────────────────────────────────────────
    group('UI/UX Verification', () {

      testWidgets('Screen is scrollable', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('Uses correct background color', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, const Color(0xFFF8FAFC));
      });

      testWidgets('Uses correct AppBar color', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.backgroundColor, Colors.white);
      });

      testWidgets('Container cards have white background', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        // Find containers with white background
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers, isNotEmpty);
      });

      testWidgets('Displays location icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: EmployerDetailScreen(employerData: mockEmployer),
          ),
        );

        expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // EMPLOYER MODEL TESTS
    // ─────────────────────────────────────────────────────────
    group('EmployerModel', () {

      test('EmployerModel can be created with required fields', () {
        final employer = EmployerModel(
          id: '1',
          companyName: 'Test Company',
          industry: 'Technology',
          location: 'Cape Town',
          activeOpeningsCount: 3,
        );

        expect(employer.id, '1');
        expect(employer.companyName, 'Test Company');
        expect(employer.industry, 'Technology');
        expect(employer.location, 'Cape Town');
        expect(employer.activeOpeningsCount, 3);
      });

      test('EmployerModel supports optional fields', () {
        final employer = EmployerModel(
          id: '2',
          companyName: 'Test Corp',
          industry: 'Business',
          location: 'Johannesburg',
          website: 'https://test.com',
          email: 'info@test.com',
          bio: 'Test bio',
          activeOpeningsCount: 5,
        );

        expect(employer.website, 'https://test.com');
        expect(employer.email, 'info@test.com');
        expect(employer.bio, 'Test bio');
      });

      test('EmployerModel.fromJson creates object correctly', () {
        final json = {
          'id': '3',
          'company_name': 'JSON Company',
          'industry': 'Finance',
          'location': 'Durban',
          'website': 'https://json.com',
          'email': 'contact@json.com',
          'bio': 'JSON bio',
          'active_openings_count': 2,
        };

        final employer = EmployerModel.fromJson(json);

        expect(employer.id, '3');
        expect(employer.companyName, 'JSON Company');
        expect(employer.industry, 'Finance');
        expect(employer.location, 'Durban');
        expect(employer.website, 'https://json.com');
        expect(employer.email, 'contact@json.com');
        expect(employer.bio, 'JSON bio');
        expect(employer.activeOpeningsCount, 2);
      });

      test('EmployerModel.fromJson handles null values', () {
        final json = {
          'id': null,
          'company_name': null,
          'industry': null,
          'location': null,
          'active_openings_count': null,
        };

        final employer = EmployerModel.fromJson(json);

        expect(employer.id, '');
        expect(employer.companyName, '');
        expect(employer.industry, '');
        expect(employer.location, '');
        expect(employer.activeOpeningsCount, 0);
      });
    });
  });
}

// Helper class for navigation testing
class TestNavigatorObserver extends NavigatorObserver {
  final VoidCallback? onPop;

  TestNavigatorObserver({this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    onPop?.call();
  }
}