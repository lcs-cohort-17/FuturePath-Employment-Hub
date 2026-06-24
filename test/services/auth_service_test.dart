// test/services/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('signOut should complete without error', () async {
      await expectLater(authService.signOut(), completes);
    });

    test('isLoggedIn should return a boolean', () {
      final result = authService.isLoggedIn;
      expect(result, isA<bool>());
    });

    test('AuthService singleton should return an instance', () {
      expect(authService, isA<AuthService>());
    });
  });
}