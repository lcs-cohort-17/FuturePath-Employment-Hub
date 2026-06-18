// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('logout should complete without error', () async {
      // Should not throw
      await expectLater(authService.logout(), completes);
    });

    test('isLoggedIn should return a boolean', () async {
      final result = await authService.isLoggedIn();
      expect(result, isA<bool>());
    });

    test('authServiceProvider should provide AuthService', () {
      final container = ProviderContainer();
      final service = container.read(authServiceProvider);
      expect(service, isA<AuthService>());
    });
  });
}// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('logout should complete without error', () async {
      // Should not throw
      await expectLater(authService.logout(), completes);
    });

    test('isLoggedIn should return a boolean', () async {
      final result = await authService.isLoggedIn();
      expect(result, isA<bool>());
    });

    test('authServiceProvider should provide AuthService', () {
      final container = ProviderContainer();
      final service = container.read(authServiceProvider);
      expect(service, isA<AuthService>());
    });
  });
}