import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/router/app_router.dart';
import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';
import 'package:futurepath_employment_hub/screens/shell/main_shell.dart';

void main() {
  Widget buildTestApp({String initialRoute = AppRouter.login}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }

  Future<void> loginSuccessfully(WidgetTester tester) async {
    expect(find.byType(LoginScreen), findsOneWidget);

    final passwordField = find.byType(TextFormField).at(1);

    await tester.ensureVisible(passwordField);
    await tester.pumpAndSettle();

    await tester.enterText(passwordField, 'password123');

    final loginButton = find.widgetWithText(FilledButton, 'Log In');

    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();

    await tester.tap(loginButton);
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('NAV-005: Login > Home and Logout > Login Navigation', () {
    testWidgets(
      'successful login navigates to Home using replacement',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestApp());

        await loginSuccessfully(tester);

        expect(find.byType(AppShell), findsOneWidget);
        expect(find.text('Home Screen'), findsOneWidget);

        final navigator = tester.state<NavigatorState>(
          find.byType(Navigator),
        );

        expect(
          navigator.canPop(),
          isFalse,
          reason: 'Login should be removed from the back stack after login.',
        );
      },
    );

    testWidgets(
      'logout from Profile clears stack and returns to Login',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestApp());

        await loginSuccessfully(tester);

        expect(find.byType(AppShell), findsOneWidget);

        final profileTab = find.byIcon(Icons.person_outline);

        await tester.ensureVisible(profileTab);
        await tester.tap(profileTab);
        await tester.pumpAndSettle();

        expect(find.text('Profile'), findsWidgets);

        final logoutButton = find.widgetWithText(FilledButton, 'Log Out');

        await tester.ensureVisible(logoutButton);
        await tester.pumpAndSettle();

        await tester.tap(logoutButton);
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);

        final navigator = tester.state<NavigatorState>(
          find.byType(Navigator),
        );

        expect(
          navigator.canPop(),
          isFalse,
          reason: 'Protected screens should be removed after logout.',
        );
      },
    );

    testWidgets(
      'logged out user cannot access /home directly',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildTestApp(initialRoute: AppRouter.home),
        );

        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);

        final navigator = tester.state<NavigatorState>(
          find.byType(Navigator),
        );

        expect(
          navigator.canPop(),
          isFalse,
          reason: 'Unauthenticated /home access should redirect to Login only.',
        );
      },
    );
  });
}