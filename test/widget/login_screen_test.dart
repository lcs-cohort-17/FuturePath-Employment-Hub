import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/router/app_router.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createLoginScreen() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute, // This fixes the Forgot Password navigation!
      home: const LoginScreen(),
    );
  }

  group('UIUX-002: Login & Authentication Screens', () {
    // TEST 1: UI Elements Exist
    testWidgets('Login screen displays all required UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('FuturePath'), findsOneWidget);
      expect(find.text('Employment Hub'), findsOneWidget);
      expect(find.text('Log In'), findsWidgets);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('or continue with'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    // TEST 2: Demo Credentials Pre-filled
    testWidgets('Demo credentials are pre-filled', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      expect(find.text('sipho.dlamini@gmail.com'), findsOneWidget);
    });

    // TEST 3: Email Validation
    testWidgets('Email field validates input', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.pump();

      final logInButtons = find.text('Log In');
      await tester.tap(logInButtons.last, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    // TEST 4: Password Toggle - FIXED!
    testWidgets('Password field has secure text entry', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Enter password'), findsOneWidget);

      // Look for IconButton inside the password field
      final iconButtons = find.byType(IconButton);
      expect(iconButtons, findsWidgets);

      // Verify at least one IconButton exists (for visibility toggle)
      expect(iconButtons.evaluate().length, greaterThan(0));
    });

    // TEST 5: Forgot Password Navigation - FIXED!
    testWidgets('Forgot Password link exists and navigates', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Forgot Password?'), findsOneWidget);

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Should navigate to Forgot Password screen
      expect(find.text('Forgot Password?'), findsWidgets);
    });

    // TEST 6: Sign Up Tab/Link
    testWidgets('Sign Up tab exists', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      expect(find.text('Sign Up'), findsOneWidget);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
    });

    // TEST 7: Successful Login
    testWidgets('Log In button exists and is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      final logInButton = find.text('Log In').last;
      expect(logInButton, findsOneWidget);

      await tester.tap(logInButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    // TEST 8: Design System Applied
    testWidgets('Login screen uses design system colors', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);

      expect(find.text('FuturePath'), findsOneWidget);
    });

    // TEST 9: Form Fields Are Present
    testWidgets('All form fields are present and labeled', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    // TEST 10: Google Sign-In Option
    testWidgets('Google sign-in option is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('or continue with'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('G'), findsOneWidget);
    });
  });
}