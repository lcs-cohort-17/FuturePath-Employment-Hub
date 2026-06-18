import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/jobs/job_list_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/job_apply_screen.dart';
import 'package:futurepath_employment_hub/core/widgets/skill_chip.dart';

void main() {
  final mockOpportunity = Opportunity(
    id: '1',
    title: 'Junior Flutter Developer',
    company: 'TechNova Solutions',
    companyIndustry: 'Technology',
    location: 'Cape Town',
    jobType: 'Full-time',
    skills: ['Flutter', 'Dart', 'Firebase'],
    closingDate: '31 Jul 2026',
    positions: 3,
    salaryRange: 'R18,000 – R25,000',
    isOpen: true,
    description: 'TechNova Solutions is looking for a passionate Junior Flutter Developer.',
    relatedProgrammes: [],
    logoInitials: 'T',
    logoColor: AppTheme.accent,
  );

  group('UIUX-005: Opportunities Directory & Details', () {

    group('Opportunities List Screen', () {

      testWidgets('Search bar is displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
        expect(find.textContaining('Search jobs'), findsOneWidget);
      });

      testWidgets('Skill filter chips are displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.text('Flutter'), findsWidgets);
        expect(find.text('Python'), findsWidgets);
        expect(find.text('SQL'), findsWidgets);
        expect(find.text('Salesforce'), findsWidgets);
        expect(find.text('Digital Marketing'), findsWidgets);
      });

      testWidgets('Job type filter is displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.text('All Types'), findsOneWidget);
        expect(find.text('Full-time'), findsWidgets);
        expect(find.text('Part-time'), findsWidgets);
        expect(find.text('Internship'), findsWidgets);
        expect(find.text('Learnership'), findsWidgets);
      });

      testWidgets('Opportunity count is displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.textContaining('opportunities found'), findsOneWidget);
      });

      testWidgets('Sort control is displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.text('SORT'), findsOneWidget);
        expect(find.text('Most Relevant'), findsOneWidget);
      });

      testWidgets('Location filter exists', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.text('All Locations'), findsOneWidget);
        expect(find.text('Cape Town'), findsWidgets);
        expect(find.text('Johannesburg'), findsWidgets);
      });

      testWidgets('Pull-to-refresh is enabled', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('Opportunity cards are displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.text('Junior Flutter Developer'), findsOneWidget);
        expect(find.text('Salesforce Administrator Intern'), findsOneWidget);
      });

      testWidgets('Tapping opportunity card navigates to detail screen', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        await tester.tap(find.text('Junior Flutter Developer'));
        await tester.pumpAndSettle();

        expect(find.byType(OpportunityDetailScreen), findsOneWidget);
      });

      testWidgets('Tapping employer name navigates to Employer Detail', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        await tester.tap(find.text('TechNova Solutions'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Employer Detail Screen'), findsOneWidget);
      });
    });

    group('Opportunity Detail Screen', () {

      testWidgets('Detail screen displays position title', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.text('Junior Flutter Developer'), findsOneWidget);
      });

      testWidgets('Detail screen displays company name', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.text('TechNova Solutions'), findsOneWidget);
      });

      testWidgets('Detail screen displays location', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.text('Cape Town'), findsOneWidget);
      });

      testWidgets('Detail screen displays job type', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.text('Full-time'), findsOneWidget);
      });

      testWidgets('Detail screen displays salary range', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.textContaining('R18,000'), findsOneWidget);
      });

      testWidgets('Detail screen displays closing date', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.textContaining('31 Jul 2026'), findsOneWidget);
      });

      testWidgets('Detail screen displays position description', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.textContaining('TechNova Solutions is looking for'), findsOneWidget);
      });

      testWidgets('Detail screen displays required skills', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.text('Flutter'), findsOneWidget);
        expect(find.text('Dart'), findsOneWidget);
        expect(find.text('Firebase'), findsOneWidget);
      });

      testWidgets('Detail screen displays number of positions', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.textContaining('3 positions'), findsOneWidget);
      });

      testWidgets('Apply Now button is displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        expect(find.text('Apply Now'), findsOneWidget);
      });

      testWidgets('Apply Now button navigates to application form', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: OpportunityDetailScreen(opportunity: mockOpportunity),
          ),
        );

        await tester.tap(find.text('Apply Now'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Apply'), findsWidgets);
      });
    });

    group('Filtering Functionality', () {

      testWidgets('Skill filter chips filter jobs', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.text('2 opportunities found'), findsOneWidget);

        await tester.tap(find.text('Flutter').first);
        await tester.pumpAndSettle();

        expect(find.text('1 opportunity found'), findsOneWidget);
      });

      testWidgets('Job type filter filters opportunities', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpportunityListScreen(),
          ),
        );

        expect(find.text('2 opportunities found'), findsOneWidget);

        await tester.tap(find.text('Full-time').first);
        await tester.pumpAndSettle();

        expect(find.text('1 opportunity found'), findsOneWidget);
      });

      testWidgets('Location filter filters opportunities', (WidgetTester tester) async {
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
    });
  });
}