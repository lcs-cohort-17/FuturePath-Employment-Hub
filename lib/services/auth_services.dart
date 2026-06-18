import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate
  }

  Future<bool> isLoggedIn() async {
    return true; // Mock
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});