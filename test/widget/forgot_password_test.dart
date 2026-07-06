import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// 1. ADD THIS IMPORT FOR SHARED PREFERENCES
import 'package:shared_preferences/shared_preferences.dart';

import 'package:futurepath_employment_hub/screens/auth/forgot_password_screen.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

void main() {
  setUpAll(() async {
    // 2. MOCK THE SHARED PREFERENCES CHANNEL TO PREVENT THE EXCEPTION
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: 'https://supabase.co',
      anonKey: 'mock-anon-key-12345',
    );
  });

  group('UIUX-010: Forgot Password Screen Tests', () {

    Widget createWidgetUnderTest() {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ForgotPasswordScreen(),
          ),
        ),
      );
    }

    group('Screen Rendering', () {
      testWidgets('displays form elements correctly on load', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Email Address'), findsOneWidget);
        expect(find.text('Enter your email'), findsOneWidget);
        expect(find.text('Send Reset Link'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Form Validation', () {
      testWidgets('shows error message when email is empty', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Please enter your email address'), findsOneWidget);
      });

      testWidgets('shows error message when email format is invalid', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(find.byType(TextFormField), 'invalid-email-format');

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('clears validation error when valid email is provided', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text('Please enter your email address'), findsOneWidget);

        await tester.enterText(find.byType(TextFormField), 'test@example.com');

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.text('Please enter your email address'), findsNothing);
      });
    });
  });
}
