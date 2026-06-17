import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_detail_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_list_screen.dart';

void main() {
  group('OpportunityDetailScreen Widget Tests', () {
    final mockOpportunity = Opportunity(
      id: '1',
      title: 'Business Development Intern',
      company: 'FutureTech Africa',
      companyIndustry: 'Business',
      location: 'Pretoria, SA (Hybrid)',
      jobType: 'Internship',
      skills: ['Sales', 'CRM', 'Communication', 'Market Research', 'Microsoft Office'],
      closingDate: '25 Jul 2026',
      positions: 2,
      salaryRange: 'R10,000',
      isOpen: true,
      duration: '6 months',
      description: 'FutureTech Africa\'s Business Development team is looking for an energetic intern to support our enterprise sales pipeline.',
      relatedProgrammes: [
        RelatedProgramme(title: 'Salesforce Administration', duration: '3 months', level: 'Beginner', isOpen: true),
        RelatedProgramme(title: 'Financial Literacy & FinTech', duration: '2 months', level: 'Beginner', isOpen: true),
      ],
      logoInitials: 'F',
      logoColor: const Color(0xFF7C3AED),
    );

    testWidgets('Displays job title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.text('Business Development Intern'), findsOneWidget);
    });

    testWidgets('Displays company name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.text('FutureTech Africa'), findsOneWidget);
    });

    testWidgets('Displays location', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.text('Pretoria, SA (Hybrid)'), findsOneWidget);
    });

    testWidgets('Displays job type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      // Use contains because "Internship" appears in multiple places
      expect(find.textContaining('Internship'), findsWidgets);
    });

    testWidgets('Displays positions count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.textContaining('2 positions'), findsOneWidget);
    });

    testWidgets('Displays salary range', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.textContaining('R10,000'), findsOneWidget);
    });

    testWidgets('Displays closing date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.textContaining('Closes 25 Jul 2026'), findsOneWidget);
    });

    testWidgets('Displays "Position Overview" section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.text('Position Overview'), findsOneWidget);
      // Use a unique part of the description
      expect(find.textContaining('enterprise sales pipeline'), findsOneWidget);
    });

    testWidgets('Displays "Required Skills" section with chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.text('Required Skills'), findsOneWidget);
      expect(find.text('Sales'), findsWidgets);
      expect(find.text('CRM'), findsWidgets);
      expect(find.text('Communication'), findsWidgets);
    });

    testWidgets('Displays "Prepare with These Programmes" section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.text('💡 Prepare with These Programmes'), findsOneWidget);
      expect(find.text('Salesforce Administration'), findsOneWidget);
      expect(find.text('Financial Literacy & FinTech'), findsOneWidget);
    });

    testWidgets('Displays "Apply Now" button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      expect(find.text('Apply Now'), findsOneWidget);
    });

    testWidgets('Tapping "Apply Now" navigates to placeholder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      await tester.tap(find.text('Apply Now'));
      await tester.pumpAndSettle();

      expect(find.text('Application Form - coming soon'), findsOneWidget);
    });

    testWidgets('Displays "Open" badge in app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OpportunityDetailScreen(opportunity: mockOpportunity),
        ),
      );

      // Use findsWidgets because "Open" appears in multiple places
      expect(find.text('Open'), findsWidgets);
    });
  });
}