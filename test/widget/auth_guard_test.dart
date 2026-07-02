import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/router/auth_guard.dart';
import 'package:futurepath_employment_hub/router/app_router.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart' hide authServiceProvider;
import 'package:futurepath_employment_hub/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakeAuthService implements AuthService {
  final bool _isLoggedIn;
  final User? _user;

  FakeAuthService({
    required bool isLoggedIn,
    User? user,
  })  : _isLoggedIn = isLoggedIn,
        _user = user;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  User? get currentUser => _user;

  @override
  String? get userEmail => _user?.email;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  Future<AuthResponse> signIn({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> signUp({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({required String email, required String redirectTo}) {
    throw UnimplementedError();
  }

  @override
  Future<UserResponse> updatePassword(String newPassword) {
    throw UnimplementedError();
  }
}

void main() {
  setUpAll(() {
    dotenv.loadFromString(
      envString: 'SUPABASE_URL=https://dummy.supabase.co\nSUPABASE_ANON_KEY=dummy',
    );
  });

  Widget createTestWidget({
    required bool isLoggedIn,
    User? user,
  }) {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(FakeAuthService(
          isLoggedIn: isLoggedIn,
          user: user,
        )),
      ],
      child: MaterialApp(
        initialRoute: '/protected',
        routes: {
          '/protected': (context) => const AuthGuard(
                child: Scaffold(
                  body: Text('Protected Content'),
                ),
              ),
          AppRouter.adminLogin: (context) => const Scaffold(
                body: Text('Admin Login Screen'),
              ),
          AppRouter.home: (context) => const Scaffold(
                body: Text('Applicant Home'),
              ),
        },
      ),
    );
  }

  group('AuthGuard Role Protection Tests', () {
    testWidgets('Unauthenticated user is redirected to Admin Login', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(isLoggedIn: false));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Admin Login Screen'), findsOneWidget);
      expect(find.text('Protected Content'), findsNothing);
    });

    testWidgets('Authenticated non-admin user is redirected to applicant Home', (WidgetTester tester) async {
      final user = User(
        id: 'mock-staff-1',
        email: 'staff@example.com',
        createdAt: DateTime.now().toIso8601String(),
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
      );

      await tester.pumpWidget(createTestWidget(isLoggedIn: true, user: user));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Applicant Home'), findsOneWidget);
      expect(find.text('Protected Content'), findsNothing);
    });

    testWidgets('Authenticated admin user is routed to Admin Dashboard', (WidgetTester tester) async {
      final adminUser = User(
        id: 'mock-admin-id',
        email: 'admin@futurepath.co.za',
        createdAt: DateTime.now().toIso8601String(),
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
      );

      await tester.pumpWidget(createTestWidget(isLoggedIn: true, user: adminUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Protected Content'), findsOneWidget);
      expect(find.text('Login Screen'), findsNothing);
      expect(find.text('Applicant Home'), findsNothing);
    });
  });
}
