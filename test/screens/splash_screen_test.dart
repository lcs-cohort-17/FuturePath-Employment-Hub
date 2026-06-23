import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:futurepath_employment_hub/screens/auth/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UIUX-013 Splash Screen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets(
      'renders splash content immediately',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(
              onNavigateHome: () {},
              onNavigateLogin: () {},
            ),
          ),
        );

        expect(find.text('FuturePath'), findsOneWidget);
        expect(find.text('EMPLOYMENT HUB'), findsOneWidget);
        expect(find.textContaining('Building Skills'), findsOneWidget);
      },
    );

    testWidgets(
      'shows loading indicator',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(
              onNavigateHome: () {},
              onNavigateLogin: () {},
            ),
          ),
        );

        expect(find.byType(AnimatedContainer), findsNWidgets(3));
      },
    );

    testWidgets(
      'shows branding content',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(
              onNavigateHome: () {},
              onNavigateLogin: () {},
            ),
          ),
        );

        expect(find.text('FuturePath'), findsOneWidget);
        expect(find.text('EMPLOYMENT HUB'), findsOneWidget);
      },
    );

    testWidgets(
      'does not navigate before minimum splash duration',
          (tester) async {
        SharedPreferences.setMockInitialValues({
          'session_token': 'abc123',
        });

        bool homeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(
              minimumSplashMs: 1500,
              onNavigateHome: () {
                homeCalled = true;
              },
              onNavigateLogin: () {},
            ),
          ),
        );

        await tester.pump(
          const Duration(milliseconds: 1400),
        );

        expect(homeCalled, false);
      },
    );

    testWidgets(
      'navigates to Home when session exists',
          (tester) async {
        SharedPreferences.setMockInitialValues({
          'session_token': 'abc123',
        });

        bool homeCalled = false;
        bool loginCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(
              minimumSplashMs: 100,
              onNavigateHome: () {
                homeCalled = true;
              },
              onNavigateLogin: () {
                loginCalled = true;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(homeCalled, true);
        expect(loginCalled, false);
      },
    );

    testWidgets(
      'navigates to Login when no session exists',
          (tester) async {
        SharedPreferences.setMockInitialValues({});

        bool homeCalled = false;
        bool loginCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(
              minimumSplashMs: 100,
              onNavigateHome: () {
                homeCalled = true;
              },
              onNavigateLogin: () {
                loginCalled = true;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(homeCalled, false);
        expect(loginCalled, true);
      },
    );

    testWidgets(
      'navigates only after minimum splash duration',
          (tester) async {
        SharedPreferences.setMockInitialValues({
          'session_token': 'abc123',
        });

        bool homeCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(
              minimumSplashMs: 1500,
              onNavigateHome: () {
                homeCalled = true;
              },
              onNavigateLogin: () {},
            ),
          ),
        );

        await tester.pump(
          const Duration(milliseconds: 1400),
        );

        expect(homeCalled, false);

        await tester.pump(
          const Duration(milliseconds: 200),
        );

        expect(homeCalled, true);
      },
    );
  });
}