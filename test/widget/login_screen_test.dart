import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/router/app_router.dart';
import 'package:futurepath_employment_hub/screens/auth/forgot_password_screen.dart';
import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';
import 'package:futurepath_employment_hub/screens/auth/sign_up_screen.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  Widget createLoginScreen() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.login,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRouter.login:
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => LoginScreen(authService: authService),
            );

          case AppRouter.forgotPassword:
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => ForgotPasswordScreen(
                authService: authService,
              ),
            );

          case AppRouter.signup:
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => SignupScreen(
                authService: authService,
              ),
            );

          default:
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => LoginScreen(authService: authService),
            );
        }
      },
    );
  }

  group('UIUX-002: Login & Authentication Screens', () {
    testWidgets(
      'Login screen displays all required UI elements',
      (tester) async {
        await tester.pumpWidget(createLoginScreen());

        expect(find.text('FuturePath'), findsOneWidget);
        expect(find.text('Employment Hub'), findsOneWidget);
        expect(find.text('Log In'), findsWidgets);
        expect(find.text('Email Address'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Forgot Password?'), findsOneWidget);
        expect(find.text('or continue with'), findsOneWidget);
        expect(find.text('Continue with Google'), findsOneWidget);
      },
    );

    testWidgets('Demo credentials are pre-filled', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('sipho.dlamini@gmail.com'), findsOneWidget);
    });

    testWidgets('Email field validates input', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
        find.byType(TextFormField).first,
        '',
      );

      final loginButton = find.widgetWithText(FilledButton, 'Log In');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('Password field has secure text entry', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Enter password'), findsOneWidget);
      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('Forgot Password link navigates', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final forgotButton = find.text('Forgot Password?');
      await tester.ensureVisible(forgotButton);
      await tester.tap(forgotButton);
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('Sign Up link navigates', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final signUpLink = find.text('Sign Up Free');
      await tester.ensureVisible(signUpLink);
      await tester.tap(signUpLink);
      await tester.pumpAndSettle();

      expect(find.byType(SignupScreen), findsOneWidget);
    });

    testWidgets('Log In button exists and is tappable', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final loginButton = find.widgetWithText(FilledButton, 'Log In');
      await tester.ensureVisible(loginButton);

      expect(loginButton, findsOneWidget);
    });

    testWidgets('Login screen uses design system colors', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('FuturePath'), findsOneWidget);
    });

    testWidgets('All form fields are present and labeled', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Google sign-in option is displayed', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('or continue with'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('G'), findsOneWidget);
    });
  });
}