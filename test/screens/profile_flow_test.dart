import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/screens/profile/profile_screen.dart';
import 'package:futurepath_employment_hub/screens/profile/cv_screen.dart';
import 'package:futurepath_employment_hub/providers/user_profile_provider.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

void main() {
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

    testWidgets('Hired banner should appear when user is hired', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileProvider.overrideWith((ref) => UserProfileNotifier()..updateHiredStatus(true)),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if hired banner appears
      expect(find.text("You're Hired!"), findsOneWidget);
    });

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

    testWidgets('Sign Out button should call logout', (tester) async {
      bool logoutCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(
              _MockAuthService(() => logoutCalled = true),
            ),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure Sign Out button is visible before tapping
      final signOutButton = find.text('Sign Out');
      await tester.ensureVisible(signOutButton);
      await tester.pumpAndSettle();

      // Tap Sign Out button
      await tester.tap(signOutButton);
      await tester.pumpAndSettle();

      // Verify logout was called
      expect(logoutCalled, isTrue);
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
class _MockAuthService extends AuthService {
  final VoidCallback onLogout;

  _MockAuthService(this.onLogout);

  @override
  Future<void> logout() async {
    onLogout();
  }
}
