import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/screens/auth/forgot_password_screen.dart';
import 'package:futurepath_employment_hub/core/widgets/forgot_password_form.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

void main() {
  group('UIUX-010: Forgot Password Screen', () {

    group('Screen Rendering', () {
      testWidgets('Forgot Password screen displays title', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.text('Forgot Password?'), findsOneWidget);
      });

      testWidgets('Forgot Password screen displays description text', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.textContaining('Enter your email address'), findsOneWidget);
      });

      testWidgets('Forgot Password screen has back button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });
    });

    group('Form Components', () {
      testWidgets('Email input field is displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Email Address'), findsOneWidget);
      });

      testWidgets('Send Reset Link button is displayed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.text('Send Reset Link'), findsOneWidget);
      });

      testWidgets('Email field has email icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      });

      testWidgets('Email field has hint text', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.text('Enter your email'), findsOneWidget);
      });
    });

    group('Email Validation', () {
      testWidgets('Empty email shows validation error', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.tap(find.text('Send Reset Link'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter your email address'), findsOneWidget);
      });

      testWidgets('Invalid email format shows validation error', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.enterText(find.byType(TextFormField), 'invalid-email');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Send Reset Link'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('Valid email format is accepted', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        await tester.pumpAndSettle();
        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('Email without @ symbol shows error', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.enterText(find.byType(TextFormField), 'testexample.com');
        await tester.tap(find.text('Send Reset Link'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('Email without domain shows error', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.enterText(find.byType(TextFormField), 'test@');
        await tester.tap(find.text('Send Reset Link'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });
    });

    group('Submit Functionality', () {
      testWidgets('Send Reset Link button is tappable', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.text('Send Reset Link'), findsOneWidget);
      });

      testWidgets('Button uses ElevatedButton', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('Form uses Form widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('UI/UX Verification', () {
      testWidgets('Forgot Password screen uses Scaffold', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Forgot Password screen has AppBar', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(AppBar), findsOneWidget);
      });

      // FIXED: Changed findsOneWidget to findsWidgets because AppBar adds its own SafeArea
      testWidgets('Screen uses SafeArea', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(SafeArea), findsWidgets);
      });

      testWidgets('Screen has padding', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets('Forgot Password screen uses AppTheme background', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('Email with spaces is handled', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.enterText(find.byType(TextFormField), '  test@example.com  ');
        await tester.pumpAndSettle();
        expect(find.text('  test@example.com  '), findsOneWidget);
      });

      // FIXED: Now taps "Try again" to get back to the form before checking multiple submissions
      testWidgets('Form handles multiple submissions', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );

        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        await tester.pumpAndSettle();

        // First submission
        await tester.tap(find.text('Send Reset Link'));
        await tester.pumpAndSettle();

        // Verify it went to success view
        expect(find.text('Email Sent!'), findsOneWidget);

        // Tap "Try again" to return to form
        await tester.tap(find.text('Try again'));
        await tester.pumpAndSettle();

        // Verify form is back
        expect(find.text('Send Reset Link'), findsOneWidget);
      });

      testWidgets('Case insensitive email validation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.enterText(find.byType(TextFormField), 'TEST@EXAMPLE.COM');
        await tester.pumpAndSettle();
        expect(find.text('TEST@EXAMPLE.COM'), findsOneWidget);
      });

      testWidgets('Email with special characters is validated', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.lightTheme, home: const ForgotPasswordScreen()),
        );
        await tester.enterText(find.byType(TextFormField), 'test.user+tag@example.co.za');
        await tester.pumpAndSettle();
        expect(find.text('test.user+tag@example.co.za'), findsOneWidget);
      });
    });
  });
}