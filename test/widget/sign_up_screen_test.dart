import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/router/app_router.dart';
import 'package:futurepath_employment_hub/services/registration_service.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createApp() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
      home: const LoginScreen(),
    );
  }

  group('UIUX-011: Sign Up / Registration Screen', () {

    testWidgets('Sign Up tab switches to registration form', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      expect(find.text('Log In'), findsWidgets);
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('All 13 Salesforce fields are present', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('ID Number'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Contact Number'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Residential Area'), findsOneWidget);
      expect(find.text('Highest Qualification'), findsOneWidget);
      expect(find.text('Current Employment Status'), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('Form validation blocks empty submission', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Scroll down to bring the Create Account button into view
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -2000));
      await tester.pumpAndSettle();

      // Now tap the button
      await tester.tap(find.text('Create Account'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Validation errors should appear
      expect(find.textContaining('required'), findsWidgets);
    });

    testWidgets('RegistrationService stores data locally', (WidgetTester tester) async {
      await RegistrationService.saveApplicant(
        firstName: 'Test', lastName: 'User', idNumber: '0001010000000',
        dateOfBirth: '01/01/2000', gender: 'Male', contactNumber: '0710000000',
        email: 'test@test.com', residentialArea: 'Test City',
        highestQualification: 'Matric', employmentStatus: 'Unemployed',
        skills: ['Test'],
      );
      final applicants = await RegistrationService.getApplicants();
      expect(applicants.length, 1);
      expect(applicants[0]['firstName'], 'Test');
    });

    testWidgets('AuthService saves session', (WidgetTester tester) async {
      // Save session
      await AuthService.saveSession('test@test.com');

      // Verify it was saved by checking if isLoggedIn returns true
      final isLoggedIn = await AuthService.isLoggedIn();
      expect(isLoggedIn, true);
    });
  });
}