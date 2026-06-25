import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/auth/forgot_password_screen.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();

    when(
      () => authService.resetPassword(any()),
    ).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: ForgotPasswordScreen(
        authService: authService,
      ),
    );
  }

  group('UIUX-010: Forgot Password Screen Tests', () {
    testWidgets(
      'displays form elements correctly on load',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Email Address'), findsOneWidget);
        expect(find.text('Enter your email'), findsOneWidget);
        expect(find.text('Send Reset Link'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      },
    );

    testWidgets(
      'shows error message when email is empty',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final sendButton = find.byKey(
          const Key('send_reset_link_button'),
        );
        await tester.ensureVisible(sendButton);
        await tester.tap(sendButton);
        await tester.pump();

        expect(
          find.text('Please enter your email address'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows error message when email format is invalid',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(
          find.byKey(const Key('forgot_password_email_field')),
          'invalid-email-format',
        );

        final sendButton = find.byKey(
          const Key('send_reset_link_button'),
        );
        await tester.ensureVisible(sendButton);
        await tester.tap(sendButton);
        await tester.pump();

        expect(
          find.text('Please enter a valid email address'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'valid email calls AUTH-003 resetPassword',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(
          find.byKey(const Key('forgot_password_email_field')),
          'test@example.com',
        );

        final sendButton = find.byKey(
          const Key('send_reset_link_button'),
        );
        await tester.ensureVisible(sendButton);
        await tester.tap(sendButton);
        await tester.pumpAndSettle();

        verify(
          () => authService.resetPassword('test@example.com'),
        ).called(1);

        expect(find.text('Reset link sent'), findsOneWidget);
      },
    );
  });
}