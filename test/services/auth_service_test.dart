// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('logout should complete without error', () async {
      // Should not throw
      await expectLater(authService.logout(), completes);
    });

    test('isLoggedIn should return a boolean', () {
      final result = authService.isLoggedIn;
      expect(result, isA<bool>());
    });

    test('authServiceProvider should provide AuthService', () {
      final container = ProviderContainer();
      final service = container.read(authServiceProvider);
      expect(service, isA<AuthService>());
    });
  });
}
