import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

void main() {
  group('AuthService Tests', () {
    test('AuthService should be a singleton', () {
      final auth1 = AuthService();
      final auth2 = AuthService();

      expect(identical(auth1, auth2), true);
    });

    test('AuthService instance should not be null', () {
      final auth = AuthService();

      expect(auth, isNotNull);
    });

    test('AuthService exposes required methods', () {
      final auth = AuthService();

      expect(auth.signIn, isNotNull);
      expect(auth.signUp, isNotNull);
      expect(auth.signOut, isNotNull);
      expect(auth.resetPassword, isNotNull);
    });
  });
}