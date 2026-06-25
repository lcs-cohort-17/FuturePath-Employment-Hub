import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:futurepath_employment_hub/services/auth_services.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-publishable-key',
    );
  });

  group('AuthService contract', () {
    test('exposes the AUTH-003 current-user and session state', () {
      final service = AuthService();

      expect(service.currentUser, isNull);
      expect(service.isLoggedIn, isFalse);
    });

    test('exposes both AUTH-003 and AUTH-002 auth streams', () {
      final service = AuthService();

      expect(service.authStateChange, isA<Stream<AuthState>>());
      expect(service.authStateChanges, isA<Stream<AuthState>>());
    });

    test('uses the NAV-009 password recovery redirect URL', () {
      expect(
        AuthService.passwordResetRedirectUrl,
        'io.futurepath://reset-password',
      );
    });
  });
}