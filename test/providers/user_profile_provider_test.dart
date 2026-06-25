import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:futurepath_employment_hub/screens/profile/profile_screen.dart';
import 'package:futurepath_employment_hub/screens/profile/cv_screen.dart';
import 'package:futurepath_employment_hub/providers/user_profile_provider.dart';
import 'package:futurepath_employment_hub/providers/auth_provider.dart';
import 'package:futurepath_employment_hub/router/app_router.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-publishable-key',
    );
  });

  group('Profile Screen Integration Tests', () {
    testWidgets('ProfileScreen should show user info', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      // Wait for async operations
      await tester.pumpAndSettle();

      // Check if user name is displayed
      expect(find.text('Sipho Nkosi'), findsOneWidget);

      // Check if location is displayed
      expect(find.text('Mitchells Plain, Cape Town'), findsOneWidget);

      // Check if employment status is displayed
      expect(find.text('Unemployed'), findsOneWidget);

      // Check if email is displayed
      expect(find.text('sipho.dlamini@gmail.com'), findsOneWidget);

      // Check if phone is displayed
      expect(find.text('+27 82 123 4567'), findsOneWidget);
    });

    // COMMENTED OUT: This test needs the correct provider name
    // testWidgets('Hired banner should appear when user is hired', (tester) async {
    //   await tester.pumpWidget(
    //     ProviderScope(
    //       overrides: [
    //         // TODO: Replace with actual provider name from user_profile_provider.dart
    //         userProfileNotifierProvider.overrideWith((ref) => UserProfileNotifier()..updateHiredStatus(true)),
    //       ],
    //       child: const MaterialApp(
    //         home: ProfileScreen(),
    //       ),
    //     ),
    //   );

    //   await tester.pumpAndSettle();
    //   expect(find.text("You're Hired!"), findsOneWidget);
    // });

    testWidgets('Hired banner should NOT appear when user is not hired', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if hired banner does NOT appear
      expect(find.text("You're Hired!"), findsNothing);
    });

    testWidgets('CV/Resume card should navigate to CV screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ProfileScreen(),
            onGenerateRoute: (settings) {
              if (settings.name == '/cv') {
                return MaterialPageRoute(
                  builder: (_) => const CVScreen(),
                );
              }
              return null;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure CV / Resume card is visible before tapping
      final cvCard = find.text('CV / Resume');
      await tester.ensureVisible(cvCard);
      await tester.pumpAndSettle();

      // Tap on CV/Resume card
      await tester.tap(cvCard);
      await tester.pumpAndSettle();

      // Check if CV screen appears
      expect(find.text('CV & Resume'), findsOneWidget);
    });

    testWidgets('Sign Out button should call signOut', (tester) async {
      final authService = _MockAuthService();

      when(() => authService.signOut()).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(authService),
          ],
          child: MaterialApp(
            routes: {
              AppRouter.login: (_) => const Scaffold(
                body: Center(
                  child: Text('Login'),
                ),
              ),
            },
            home: const ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final signOutButton = find.text('Sign Out');
      await tester.ensureVisible(signOutButton);
      await tester.pumpAndSettle();

      await tester.tap(signOutButton);
      await tester.pumpAndSettle();

      verify(() => authService.signOut()).called(1);
    });
  });

  group('CV Screen Integration Tests', () {
    testWidgets('Should display skills as chips', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CVScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if skills are displayed
      expect(find.text('Customer Service'), findsOneWidget);
      expect(find.text('Basic Computer Skills'), findsOneWidget);
      expect(find.text('Communication'), findsOneWidget);
    });

    testWidgets('Should add skill when user types and submits', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CVScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter skill
      await tester.enterText(
        find.byType(TextField),
        'Flutter',
      );

      // Tap add button
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Check if skill was added
      expect(find.text('Flutter'), findsOneWidget);
    });
  });
}

// Mock AuthService for testing
class _MockAuthService extends Mock implements AuthService {}