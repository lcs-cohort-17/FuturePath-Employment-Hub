import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/router/app_router.dart';
import 'package:futurepath_employment_hub/screens/auth/forgot_password_screen.dart';
import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';
import 'package:futurepath_employment_hub/screens/auth/reset_password_screen.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  Widget buildLoginApp() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRouter.login:
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => LoginScreen(authService: authService),
            );
          default:
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => LoginScreen(authService: authService),
            );
        }
      },
      home: LoginScreen(authService: authService),
    );
  }

  group('NAV-009: Forgot Password Navigation', () {
    testWidgets(
      'Forgot Password opens from Login and Cancel returns to Login',
      (tester) async {
        await tester.pumpWidget(buildLoginApp());

        final forgotButton = find.text('Forgot Password?');
        await tester.ensureVisible(forgotButton);
        await tester.tap(forgotButton);
        await tester.pumpAndSettle();

        expect(find.byType(ForgotPasswordScreen), findsOneWidget);
        expect(find.byType(LoginScreen), findsNothing);

        await tester.tap(
          find.byKey(const Key('forgot_password_cancel_button')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(ForgotPasswordScreen), findsNothing);
      },
    );

    testWidgets(
      'Android back from Forgot Password returns to Login',
      (tester) async {
        await tester.pumpWidget(buildLoginApp());

        final forgotButton = find.text('Forgot Password?');
        await tester.ensureVisible(forgotButton);
        await tester.tap(forgotButton);
        await tester.pumpAndSettle();

        expect(find.byType(ForgotPasswordScreen), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(ForgotPasswordScreen), findsNothing);
      },
    );

    testWidgets(
      'successful reset request shows success and returns to Login',
      (tester) async {
        when(
          () => authService.resetPassword(any()),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(buildLoginApp());

        final forgotButton = find.text('Forgot Password?');
        await tester.ensureVisible(forgotButton);
        await tester.tap(forgotButton);
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('forgot_password_email_field')),
          'jose@example.com',
        );

        final sendButton = find.byKey(const Key('send_reset_link_button'));
        await tester.ensureVisible(sendButton);
        await tester.tap(sendButton);
        await tester.pumpAndSettle();

        expect(find.text('Reset link sent'), findsOneWidget);

        await tester.tap(
          find.byKey(const Key('forgot_password_success_button')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(ForgotPasswordScreen), findsNothing);

        verify(
          () => authService.resetPassword('jose@example.com'),
        ).called(1);
      },
    );

    testWidgets(
      'Reset Password requires matching passwords',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: ResetPasswordScreen(authService: authService),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('new_password_field')),
          'Password1',
        );
        await tester.enterText(
          find.byKey(const Key('confirm_password_field')),
          'Password2',
        );

        final updateButton = find.byKey(const Key('update_password_button'));
        await tester.ensureVisible(updateButton);
        await tester.tap(updateButton);
        await tester.pumpAndSettle();

        expect(find.text('Passwords do not match'), findsOneWidget);
        verifyNever(() => authService.updatePassword(any()));
      },
    );

    testWidgets(
      'successful password update replaces Reset Password with Login',
      (tester) async {
        when(() => authService.updatePassword(any())).thenAnswer((_) async {});
        when(() => authService.signOut()).thenAnswer((_) async {});

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            routes: {
              AppRouter.login: (_) => LoginScreen(authService: authService),
            },
            home: ResetPasswordScreen(authService: authService),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('new_password_field')),
          'Password1',
        );
        await tester.enterText(
          find.byKey(const Key('confirm_password_field')),
          'Password1',
        );

        final updateButton = find.byKey(const Key('update_password_button'));
        await tester.ensureVisible(updateButton);
        await tester.tap(updateButton);
        await tester.pumpAndSettle();

        expect(find.text('Password updated'), findsOneWidget);

        await tester.tap(
          find.byKey(const Key('password_updated_continue_button')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(ResetPasswordScreen), findsNothing);

        final navigator = tester.state<NavigatorState>(
          find.byType(Navigator),
        );
        expect(
          navigator.canPop(),
          isFalse,
          reason: 'Reset Password must be replaced by Login.',
        );

        verify(() => authService.updatePassword('Password1')).called(1);
        verify(() => authService.signOut()).called(1);
      },
    );
  });
}