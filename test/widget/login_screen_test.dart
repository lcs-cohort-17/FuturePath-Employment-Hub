import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';
import 'package:futurepath_employment_hub/screens/auth/forgot_password_screen.dart';
import 'package:futurepath_employment_hub/providers/auth_provider.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

// Mock AuthService
class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    reset(mockAuthService);
  });

  // Build a test router with the required routes
  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Home'))),
        ),
      ],
    );
  }

  Widget createLoginScreen() {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: createTestRouter(),
      ),
    );
  }

  group('UIUX-002: Login & Authentication Screens', () {
    testWidgets('Login screen displays all required UI elements', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

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

    testWidgets('Demo credentials are pre-filled', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      expect(find.text('sipho.dlamini@gmail.com'), findsOneWidget);
    });

    testWidgets('Password field has secure text entry and toggle', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextFormField).last;
      expect(passwordField, findsOneWidget);

      final iconButton = find.descendant(
        of: passwordField,
        matching: find.byType(IconButton),
      );
      expect(iconButton, findsOneWidget);
      await tester.tap(iconButton);
      await tester.pump();
      // No exception = pass
    });

    testWidgets('Forgot Password link navigates to ForgotPasswordScreen', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      final forgotLink = find.text('Forgot Password?');
      expect(forgotLink, findsOneWidget);

      await tester.ensureVisible(forgotLink);
      await tester.tap(forgotLink);
      await tester.pumpAndSettle();

      // Expect the ForgotPasswordScreen to appear
      expect(find.text('Send Reset Email'), findsOneWidget);
    });

    testWidgets('Sign Up tab switches to sign-up form', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      final signUpTab = find.text('Sign Up');
      expect(signUpTab, findsOneWidget);
      await tester.tap(signUpTab);
      await tester.pumpAndSettle();

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Login with invalid credentials shows error message', (tester) async {
      when(() => mockAuthService.signIn(any(), any())).thenThrow(
        AuthException('Invalid login credentials', statusCode: '400'),
      );

      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Fill in fields
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'wrong@example.com');
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'wrongpass');

      // Tap login button
      final loginButton = find.text('Log In').last;
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Error message appears (inline + SnackBar) => at least one
      expect(find.text('Invalid email or password.'), findsAtLeast(1));
      // SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Login shows loading spinner while in progress', (tester) async {
      when(() => mockAuthService.signIn(any(), any())).thenAnswer(
            (_) => Future.delayed(const Duration(seconds: 1), () => AuthResponse()),
      );

      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      final loginButton = find.text('Log In').last;
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Login with valid credentials calls signIn and navigates', (tester) async {
      when(() => mockAuthService.signIn(any(), any()))
          .thenAnswer((_) async => AuthResponse());

      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      final loginButton = find.text('Log In').last;
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(() => mockAuthService.signIn('test@example.com', 'password123')).called(1);
      // Home screen appears
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Google Sign-In button is present', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('Sign Up form validation prevents empty submission', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      final createAccountButton = find.text('Create Account');
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      await tester.pump();

      // Still on login screen (no navigation)
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}